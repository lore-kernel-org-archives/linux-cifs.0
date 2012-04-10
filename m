From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: 3.4.0-rc2+ - CIFS mount failure
Date: Tue, 10 Apr 2012 14:13:27 +0100
Message-ID: <201204101413.27748.chris2553@googlemail.com>
References: <201204100823.24207.chris2553@googlemail.com> <1334050772.2149.4.camel@localhost> <20120410071630.567d70cb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120410071630.567d70cb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tuesday 10 April 2012 12:16:30 Jeff Layton wrote:
> On Tue, 10 Apr 2012 10:39:32 +0100
>
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Tue, 2012-04-10 at 08:23 +0100, Chris Clayton wrote:
> > > HI,
> > >
> > > I'm testing the latest and greatest from Linus' tree and can't mount
> > > partitions on a nas server. The mounts work fine with 3.3.1. For the
> > > failing kernel, git describe gives v3.4-rc2-2-g258f742.
> > >
> > > What I see is:
> > >
> > > [chris:~]$ sudo mount /media/nas/share
> > > mount error(22): Invalid argument
> > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > >
> > > Dmesg shows the message:
> > >
> > > CIFS: Unknown mount option "user="
> > >
> > > The related entry in /etc/fstab is:
> > >
> > > //nas/Share /media/nas/share cifs
> > > rw,noauto,nosuid,nodev,user,guest,uid=1000,gid=100,file_mode=0666  0 0
> > >
> > > Let me know how I can help fix this regression.
> > >
> > > Please cc me - I'm not subscribed.
> > >
> > > Thanks
> > >
> > > Chris
> >
> > Chris,
> >
> > This was caused due to a regression introduced by the patch with commit
> > 8830d7e07a5e38bc47650a7554b7c1cfd49902bf
> > which cleaned up the mount options parser.
> >
> > The patch doesn't handle blank user= mount option passed as a mount
> > option. The patch is trivial and requires similar handling as the blank
> > password option.
> > http://article.gmane.org/gmane.linux.kernel.cifs/5762
> >
> > Sachin Prabhu
>
> Sachin's working on a patch to fix this. In the meantime you can
> replace the "guest" option with "sec=none" and it should work as
> expected.

If it helps, here's the patch that I cooked up before I received Jeff's advice. I hadn't finished 
making sure it is a good patch, but my first attempt at a mount did seem to work.

Signed-off-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>

--- linux/fs/cifs/connect.c~    2012-04-10 11:38:23.000000000 +0100
+++ linux/fs/cifs/connect.c     2012-04-10 12:16:02.000000000 +0100
@@ -110,6 +110,9 @@ enum {
        /* Options which could be blank */
        Opt_blank_pass,

+       /* Usernames which could be blank */
+       Opt_blank_user,
+
        Opt_err
 };

@@ -183,6 +186,7 @@ static const match_table_t cifs_mount_op
        { Opt_wsize, "wsize=%s" },
        { Opt_actimeo, "actimeo=%s" },

+       { Opt_blank_user, "user=" },
        { Opt_user, "user=%s" },
        { Opt_user, "username=%s" },
        { Opt_blank_pass, "pass=" },
@@ -1534,6 +1538,10 @@ cifs_parse_mount_options(const char *mou

                /* String Arguments */

+               case Opt_blank_user:
+                       vol->username = NULL;
+                       vol->nullauth = 1;
+                       break;
                case Opt_user:
                        string = match_strdup(args);
                        if (string == NULL)

-- 
The more I see, the more I know. The more I know, the less I understand. Changing Man - Paul Weller
