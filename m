From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: vim reports file having changed
Date: Thu, 1 Dec 2011 10:44:17 -0500
Message-ID: <20111201104417.4b3ce577@barsoom.rdu.redhat.com>
References: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes =?UTF-8?B?VGhyw6Ru?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 30 Nov 2011 15:25:01 +0100
Johannes Thr=C3=A4n <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:

> Hi all,
>=20
> I reported this before here, it somehow went under. So I'll try again=
:
>=20
> When I open a file which is located on a cifs-mounted windows share
> with vim, vim will after some time always report the file as having
> changed upon saving, regardless whether it has actually changed or
> not.
>=20
> I reported this also to the vim maintainer who told me, there he
> doesn't know of a similar problem with samba. Ergo it's probably a
> problem with cifs.
> I work on a daily basis with mentioned setup, so I would be vary glad
> to help resolve it.
>=20
> mount.cifs -v gives 4.5, I use kubuntu 11.04 and vim 7.2
>=20

Unfortunately, this sort of report doesn't help us to help you very
much. I have no idea what vim is actually complaining about when it
says that the file has changed.

As it's a kernel filesystem, it primarily deals with userspace code via
system calls. If you can phrase your problem in that context then
that would help. We'd need to know what vim is actually looking at to
detect that the file has changed. Is it the mtime?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
