From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: Add information about noserverino
Date: Thu, 9 Dec 2010 15:56:27 -0500
Message-ID: <20101209155627.16d524cd@tlielax.poochiereds.net>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
	<20101206095725.78422138@tlielax.poochiereds.net>
	<20101206101214.52a24415@tlielax.poochiereds.net>
	<20101206163506.56232lqqhc5c3co4@webmail.df.eu>
	<20101206103836.0714369a@tlielax.poochiereds.net>
	<4D00C02C.4070006@suse.de>
	<20101209070952.24793c23@barsoom.rdu.redhat.com>
	<AANLkTimm=Ca51y-4kZwpBCiBoSUjxz=maYz6J=ys2z6C@mail.gmail.com>
	<20101209143448.5c479e50@barsoom.rdu.redhat.com>
	<AANLkTikKkOEO1gZFCD+aVwVTCEXmR9Q6jVndrX6Bd08V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	sfrench@samba.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTikKkOEO1gZFCD+aVwVTCEXmR9Q6jVndrX6Bd08V@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 9 Dec 2010 14:44:27 -0600
Steve French <smfrench@gmail.com> wrote:

> On Thu, Dec 9, 2010 at 1:34 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > On Thu, 9 Dec 2010 12:26:39 -0600
> > Steve French <smfrench@gmail.com> wrote:
> >
> >> On Thu, Dec 9, 2010 at 6:09 AM, Jeff Layton <jlayton@redhat.com> wrote:
> >> > On Thu, 09 Dec 2010 17:10:28 +0530
> >> > Suresh Jayaraman <sjayaraman@suse.de> wrote:
> >> >
> >> >> On 12/06/2010 09:08 PM, Jeff Layton wrote:
> >> >> > On Mon, 06 Dec 2010 16:35:06 +0100
> >> >> > Bernhard Walle <bernhard@bwalle.de> wrote:
> >> >> >
> >> >> >>
> >> >> >> Zitat von Jeff Layton <jlayton@redhat.com>:
> >> >> >>
> >> >> >>>
> >> >> >>> I'm still not sure I like this patch however. It potentially me=
ans a
> >> >> >>> lot of printk spam since these things have no ratelimiting. It =
also
> >> >> >>> doesn't tell me anything about which server might be giving me =
grief.
> >> >> >>>
> >> >> >>> Maybe this should be turned into a cFYI?
> >> >> >>
> >> >> >> Well, if I see it in the kernel log, it doesn't matter if it's i=
nfo or
> >> >> >> something else.
> >> >> >>
> >> >> >>> The bottom line though is that running 32-bit applications that=
 were
> >> >> >>> built without -D_FILE_OFFSET_BITS=3D64 on a 64-bit kernel is a =
very bad
> >> >> >>> idea. It would be nice to be able to alert users that things ar=
en't
> >> >> >>> working the way they expect, but I'm not sure this is the right=
 place
> >> >> >>> to do that.
> >> >> >>
> >> >> >> Well, but there *are* such application (in my case it was Softma=
ker Office
> >> >> >> which is a proprietary word processor) and it's quite nice if yo=
u know
> >> >> >> how you can workaround it when you encounter such a problem. Tha=
t's all.
> >> >> >>
> >> >> >
> >> >> > Sure...but this problem is not limited to CIFS. Many modern files=
ystems
> >> >> > use 64-bit inodes. Running this application on XFS or NFS for ins=
tance
> >> >> > is likely to give you the same trouble. You just hit it on CIFS b=
ecause
> >> >> > the server happened to give you a very large inode number.
> >> >> >
> >> >> > If we're going to add printk's for this situation, it probably ou=
ght to
> >> >> > be in a more generic place.
> >> >> >
> >> >>
> >> >> By generic place, did you mean at the VFS level? I think at VFS lev=
el,
> >> >> there is little information about the Server or underlying fs and t=
his
> >> >> information doesn't seem too critical that VFS should warn/care muc=
h about.
> >> >>
> >> >> May be sticking to a cFYI along with Server detail is a good idea?
> >> >>
> >> > My poing was mainly that there's nothing special about CIFS in this
> >> > regard, other than the fact that servers regularly send us inodes th=
at
> >> > are larger than 2^32. Why should we do this for cifs but not for nfs,
> >> > xfs, ext4, etc?
> >> >
> >> > The filldir function gets a dentry as an argument, so it could
> >> > reasonably generate a printk for this. I'm also not keen on
> >> > the printk recommending noserverino for this. That has its own
> >> > drawbacks.
> >> >
> >> > A cFYI for this sort of thing seems reasonable however.
> >>
> >> I agree that a cFYI is reasonable. =A0The next obvious question is: do
> >> we need to add code to generate unique 32 bit inode numbers
> >> that don't collide (as IIRC Samba does by xor the high and low 32
> >> bits of the inode number) when the app can't support ino64
> >> I would prefer not to go back to noserverino since that has worse
> >> drawbacks.
> >>
> >
> > Right, the fact that noserverino works around this is really just due
> > to an implementation detail of iunique(). That should probably be
> > discouraged as a solution since it's not guaranteed to be a workaround
> > in the future.
> >
> > If we did add such a switch, I'd suggest that we pattern it after what
> > NFS did for this. They added an "enable_ino64" module parameter a
> > couple of years ago that defaults to "true".
>=20
> makes me uncomfortable to break ino64 for all mounts - when we
> may have one application on one mount that needs it (might be
> better to make a mount related)
>=20

It's a workaround for broken applications. Some discomfort is
reasonable, as long as the default is that ino64 is enabled.

--=20
Jeff Layton <jlayton@redhat.com>
