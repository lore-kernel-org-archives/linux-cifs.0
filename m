From: Milan <milandima-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Mounting the SD Card of a multi functional Network printer
Date: Mon, 5 May 2014 23:51:56 +0200
Message-ID: <CAAK9Yw4LRi4oBa5DAxTaePzd3NT0yUqxXNpX6kRxn3tdGXsfiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I have a HP 7500A MFC that I use to scan a lot of documents on the local SD
Card. Once in a while I want to move all the scans from the SD Card to my
computer. For this I've wrote a bash script which worked perfectly on my
Mac:



#!/bin/bash
#this is a comment-the first line sets bash as the shell script
cd ~
mkdir sharescan
mount -t smbfs smb://192.168.1.35/MEMORY_CARD/HPSCANS/ sharescan
cd sharescan
mydate=`date +%Y%m%d%H%M%S;`
for filename in scan*; do mv "$filename" "${filename//scan/$mydate _}";
done
mv *.* /Users/Mac/Dropbox/Scans
cd ..
umount ./sharescan
rmdir sharescan
exit;



Now I tried to adapt this script to my Linux Mint 16 Petra (MATE 32 bit)
machine without success.
I am unable to mount the SD Card. I can ping to it but can not mount it.



user-DQ155A-B14-T335-BE user # mount -t cifs
//192.168.1.35/MEMORY_CARD/HPSCANS/ sharescan -o guest
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)



I don't know what else I can try, do you guys have any idea?

regards,
Milan
