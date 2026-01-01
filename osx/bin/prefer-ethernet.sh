#!/bin/bash
#
# prefer-ethernet.sh
# Prefer 10G ethernet over Wi-Fi when both are connected
#

SERVICE_NAME="Solo 10G"
WIFI_INTERFACE="en0"

# Get the interface name for the 10G service
get_ethernet_interface() {
  networksetup -listnetworkserviceorder | grep -A1 "$SERVICE_NAME" | grep "Device:" | sed 's/.*Device: \([^)]*\).*/\1/'
}

# Get the router/gateway for a service
get_gateway() {
  local service="$1"
  networksetup -getinfo "$service" 2>/dev/null | grep "^Router:" | awk '{print $2}'
}

# Check if an interface has an IP address
interface_has_ip() {
  local iface="$1"
  ifconfig "$iface" 2>/dev/null | grep -q "inet "
}

# Get current default route interface
get_default_interface() {
  route -n get default 2>/dev/null | grep "interface:" | awk '{print $2}'
}

main() {
  local eth_iface
  eth_iface=$(get_ethernet_interface)

  if [[ -z "$eth_iface" ]]; then
    # Service not found
    exit 0
  fi

  # Check if 10G ethernet has an IP
  if ! interface_has_ip "$eth_iface"; then
    # 10G not connected, nothing to do
    exit 0
  fi

  # Get the current default interface
  local current_default
  current_default=$(get_default_interface)

  if [[ "$current_default" == "$eth_iface" ]]; then
    # Already using 10G, nothing to do
    exit 0
  fi

  # Get gateway for 10G
  local gateway
  gateway=$(get_gateway "$SERVICE_NAME")

  if [[ -z "$gateway" ]]; then
    # No gateway configured
    exit 0
  fi

  # Switch default route to 10G
  # Note: This requires sudo, which the LaunchAgent runs as root
  route delete default >/dev/null 2>&1
  route add default "$gateway" -interface "$eth_iface" >/dev/null 2>&1

  logger -t prefer-ethernet "Switched default route to $SERVICE_NAME ($eth_iface) via $gateway"
}

main "$@"
