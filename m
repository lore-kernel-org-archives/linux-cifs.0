From: Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
Subject: Fw: Re: Kernel oops: NULL pointer dereference in cifs_ioctl on 2.6.37-rc1
Date: Mon, 8 Nov 2010 18:30:42 +0000 (GMT)
Message-ID: <978068.36747.qm@web27102.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Forgot to include list as cc.

--- Den man 2010-11-08 skrev Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>:

> Fra: Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
> Emne: Re: Kernel oops: NULL pointer dereference in cifs_ioctl on 2.6.37-rc1
> Til: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Dato: Mandag 8. november 2010 19.28
> --- Den man 2010-11-08 skrev Jeff
> Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > Ok, the patch I just sent to the list seems to fix
> this for
> > me and this
> > is clearly our bug. But, I have to wonder -- what is
> wine
> > doing running
> > ioctls against files?
> 
> I haven't tested the patch but since you feel quite sure
> this is it I'll refile if it's still there in an rc or two,
> and now I know how to properly report an oops too. Wine is
> running utorrent.exe which is downloading to/seeding from a
> mounted cifs folder, so no mystery there. The mystery was
> just that I could navigate and play movies and everything
> from dolphin/vlc and so on, which didn't trigger the bug.
> 
> Regards,
> Kjell Rune
> 
> 
> 
