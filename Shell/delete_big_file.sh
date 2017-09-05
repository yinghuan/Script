git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch Project/NewsMaster/Pods/TTNetworkManager/Pod/Classes/TTNetworkBase/Chromium/libs/libnet.a ' \
  --prune-empty --tag-name-filter cat -- --all