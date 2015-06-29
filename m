From: dark.star777-NKkJACngtoFBDgjK7y7TUQ@public.gmane.org
Subject: permissions
Date: Mon, 29 Jun 2015 16:49:07 +0200
Message-ID: <0M8lr8-1ZLiNb0OaK-00CDlm@mail.gmx.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

hi
i know this is a very hoary old chestnut and crops up all the time 
but i am utterly stumped and cant find a solution.


i've got small mobile device whic is a linio plextalk
its running win ce to do its stuff
it exports a samba/cifs share
and i canmount it  but i cant access anything on it.
read or write.

  i went through the manwell and tried every combination of security user file modes groups and passwords i can find but its not haivng any of it.
so its not the mount options.

have trid it on a 2.6.33.5 and 3.0 and 3.4 kernel mount
on vanilla linux/debian wheezy and bananian,same problem m so its not the cifs version.

i treid dumping the tcp msgs and its sending the smb blocks ok but i cant get past the permissions problem.

i can access it ok form win xp, service pack 2.
ok its somethign to do with the way win ce does the permissions and how these are translated for linux
any suggestions as to how to go about debugging this woudl be much appreciated.


ta muchly
neil foster
