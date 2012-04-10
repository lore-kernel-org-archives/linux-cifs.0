From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: 3.4.0-rc2+ - CIFS mount failure
Date: Tue, 10 Apr 2012 07:16:30 -0400
Message-ID: <20120410071630.567d70cb@tlielax.poochiereds.net>
References: <201204100823.24207.chris2553@googlemail.com>
	<1334050772.2149.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334050772.2149.4.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 10 Apr 2012 10:39:32 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 2012-04-10 at 08:23 +0100, Chris Clayton wrote:
> > HI,
> > 
> > I'm testing the latest and greatest from Linus' tree and can't mount partitions 
> > on a nas server. The mounts work fine with 3.3.1. For the failing kernel, git 
> > describe gives v3.4-rc2-2-g258f742.
> > 
> > What I see is:
> > 
> > [chris:~]$ sudo mount /media/nas/share
> > mount error(22): Invalid argument
> > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > 
> > Dmesg shows the message:
> > 
> > CIFS: Unknown mount option "user="
> > 
> > The related entry in /etc/fstab is:
> > 
> > //nas/Share /media/nas/share cifs 
> > rw,noauto,nosuid,nodev,user,guest,uid=1000,gid=100,file_mode=0666  0 0
> > 
> > Let me know how I can help fix this regression.
> > 
> > Please cc me - I'm not subscribed.
> > 
> > Thanks
> > 
> > Chris
> 
> 
> Chris,
> 
> This was caused due to a regression introduced by the patch with commit
> 8830d7e07a5e38bc47650a7554b7c1cfd49902bf
> which cleaned up the mount options parser.
> 
> The patch doesn't handle blank user= mount option passed as a mount
> option. The patch is trivial and requires similar handling as the blank
> password option.
> http://article.gmane.org/gmane.linux.kernel.cifs/5762
> 
> Sachin Prabhu
> 

Sachin's working on a patch to fix this. In the meantime you can
replace the "guest" option with "sec=none" and it should work as
expected.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
