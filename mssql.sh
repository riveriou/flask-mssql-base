#!/bin/bash


curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#Download appropriate package for the OS version
#Choose only ONE of the following, corresponding to your OS version

#Ubuntu 20.04
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
apt-get update

ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev mssql-server
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
cd /tmp                                                                         
                                                                                
# Create the conf file for root to specify the soft stack limit.                
#                                                                               
# When running in docker - we start sqlserver as root.                          
# Also set the same limit for user 'mssql' if we decide                         
# to run as that user in the future.                                            
#                                                                               
# This is done to ensure that the sqlservr (started under user mssql)           
# doesn't  fallback to a legacy VA layout and place mmap_base at ~42TB.         
#                                                                               
echo "root soft stack 8192" > /etc/security/limits.d/99-mssql-server.conf       
echo "mssql soft stack 8192" >> /etc/security/limits.d/99-mssql-server.conf     
                                                                                
# Install required packages                                                     
#                                                                               
                                                                                                                                                                              
#apt-get -y install python3 python3-dev
                                                                                
# Configure UTF-8 locale                                                        
#                                                                               
echo "zh_TW.UTF-8 UTF-8" > /etc/locale.gen                                      
locale-gen                                                                      
                                                                                
# Install packages.microsoft.com repository configuration                       
#                                                                               
wget https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/p/packages-microsoft-prod/packages-microsoft-prod_1.0-ubuntu20.04.1_amd64.deb                             
dpkg -i packages-microsoft-prod_1.0-ubuntu20.04.1_amd64.deb 

                                                                                
# Install mssql-tools package                                                   
#                                                                                    
                                                                                
# Remove files from /tmp                                                        
#                                                                               
rm -rf /tmp/*                                                                   
                                                                                
# Remove files from apt cache                                                   
#                                                                               
apt-get clean                                                                   
rm -rf /var/lib/apt/lists/*       
