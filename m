From: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 1/1] FS/CIFS: remove obsolete __constant
Date: Mon, 5 May 2014 06:53:01 +0200
Message-ID: <20140505065301.bbb1fe3e579d27dacd3292c9@skynet.be>
References: <20140503221539.e4857ef93d6c875bbded5938@skynet.be>
	<CAOhYWNJ5JRt9KH-Z3K_zBW2axs5c5KJQYXb8_vYLQTEdr=ZeEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	akpm <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOhYWNJ5JRt9KH-Z3K_zBW2axs5c5KJQYXb8_vYLQTEdr=ZeEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 4 May 2014 18:52:43 -0400
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:

> On Sat, May 3, 2014 at 4:15 PM, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org> wrote:
> > Replacing all __constant_foo to foo()
> > except in smb2status.h (1700 lines to update).
> >
> > Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
> > ---
> >  fs/cifs/cifsacl.c  |  2 +-
> >  fs/cifs/cifssmb.c  | 20 ++++++++++----------
> >  fs/cifs/sess.c     |  2 +-
> >  fs/cifs/smb2misc.c | 38 +++++++++++++++++++-------------------
> >  fs/cifs/smb2ops.c  |  2 +-
> >  fs/cifs/smb2pdu.c  |  2 +-
> >  fs/cifs/smb2pdu.h  | 28 ++++++++++++++--------------
> >  7 files changed, 47 insertions(+), 47 deletions(-)
> >
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 7ff866d..54ac0e8 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone = {
> >         1, 1, {0, 0, 0, 0, 0, 1}, {0} };
> >  /* security id for Authenticated Users system group */
> >  static const struct cifs_sid sid_authusers = {
> > -       1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11)} };
> > +       1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
> 
> 
> Does the build still work on BE arches with this? I know at one point
> the above wouldn't compile on those
> arches. See commit 536abdb0802f, for an explanation.

Untested on BE but it would mean checkpatch 
"don't use __constant<foo> functions outside of include/uapi/" stuff is wrong ?
