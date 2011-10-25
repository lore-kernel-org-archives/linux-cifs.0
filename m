From: Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Tue, 25 Oct 2011 11:55:01 -0400
Message-ID: <20111025115501.1471db86@corrin.poochiereds.net>
References: <20111026005939.ad20ab7a2dacce216c69e821@canb.auug.org.au>
	<CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 25 Oct 2011 09:51:37 -0500
Steve French <smfrench@gmail.com> wrote:

> Am fixing it now.  Jeff missed a stub for the non-freezer case.
>=20
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index a155561..cd2d55b 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -202,6 +202,8 @@ static inline void set_freezable_with_signal(void=
) {}
>=20
>  #define wait_event_freezable_timeout(wq, condition, timeout)		\
>  		wait_event_interruptible_timeout(wq, condition, timeout)
> +#define #define wait_event_freezekillable(wq, condition)		\
> +		wait_event_killable(wq, condition)
>=20
>=20

Yep, silly oversight on my part -- sorry about that. That's exactly
what I was planning to do, so you can add my acked-by on that patch...

Thanks,
Jeff


> On Tue, Oct 25, 2011 at 8:59 AM, Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > Hi all,
> >
> > After merging the cifs tree, today's linux-next build (powerpc
> > iseries_defconfig) failed like this:
> >
> > fs/cifs/transport.c: In function 'wait_for_response':
> > fs/cifs/transport.c:328: error: implicit declaration of function 'w=
ait_event_freezekillable'
> >
> > Caused by commit f06ac72e9291 ("cifs, freezer: add
> > wait_event_freezekillable and have cifs use it"). =C2=A0In this con=
fig,
> > CONFIG_FREEZER is not set.
> > --
> > Cheers,
> > Stephen Rothwell =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0sfr@canb.auug.org.au
> > http://www.canb.auug.org.au/~sfr/
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton@redhat.com>
