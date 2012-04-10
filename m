From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.4.0-rc2+ - CIFS mount failure
Date: Tue, 10 Apr 2012 10:39:32 +0100
Message-ID: <1334050772.2149.4.camel@localhost>
References: <201204100823.24207.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201204100823.24207.chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2012-04-10 at 08:23 +0100, Chris Clayton wrote:
> HI,
> 
> I'm testing the latest and greatest from Linus' tree and can't mount partitions 
> on a nas server. The mounts work fine with 3.3.1. For the failing kernel, git 
> describe gives v3.4-rc2-2-g258f742.
> 
> What I see is:
> 
> [chris:~]$ sudo mount /media/nas/share
> mount error(22): Invalid argument
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> 
> Dmesg shows the message:
> 
> CIFS: Unknown mount option "user="
> 
> The related entry in /etc/fstab is:
> 
> //nas/Share /media/nas/share cifs 
> rw,noauto,nosuid,nodev,user,guest,uid=1000,gid=100,file_mode=0666  0 0
> 
> Let me know how I can help fix this regression.
> 
> Please cc me - I'm not subscribed.
> 
> Thanks
> 
> Chris


Chris,

This was caused due to a regression introduced by the patch with commit
8830d7e07a5e38bc47650a7554b7c1cfd49902bf
which cleaned up the mount options parser.

The patch doesn't handle blank user= mount option passed as a mount
option. The patch is trivial and requires similar handling as the blank
password option.
http://article.gmane.org/gmane.linux.kernel.cifs/5762

Sachin Prabhu
