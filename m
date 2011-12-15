From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 00/12] cifscreds: cleanup and overhaul of cifscreds
 utility
Date: Thu, 15 Dec 2011 13:59:01 -0500
Message-ID: <20111215135901.01cfec1b@barsoom.rdu.redhat.com>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
	<CADT32eKaX0Fd6iskcGtUTd0R5i+0SzMwAyjtubk-=RGZ6huB4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKaX0Fd6iskcGtUTd0R5i+0SzMwAyjtubk-=RGZ6huB4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 15 Dec 2011 12:20:15 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Dec 15, 2011 at 12:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > This patchset is a cleanup and overhaul of the cifscreds utility th=
at
> > lives in the cifs-utils tree today. Igor Druzhinin did a wonderful =
job
> > on this when he did the original code a couple of years ago, but I =
did a
> > rather poor job at the time of communicating what we actually need =
for
> > this tool to do. Mea culpa...
> >
> > This patch is a second pass at morphing it into a tool that's more =
like
> > what we need. I believe with this, I'll be able to roll some kernel
> > patches that can use the stashed key for establishing sessions.
> >
> > I've made a few changes since the last set:
> >
> > - combine some of the earlier patches so it's a smaller set
> >
> > - I've dropped the patch to make key_search use keyctl_search. I'd =
still
> > =C2=A0like to do this differently, but for now it's not possible to=
 do so
> > =C2=A0and protect the key payload
> >
> > The idea here is that we want to be able to allow users to stash th=
eir
> > NTLM credentials in the kernel, so that it's possible to establish =
a
> > session on the fly when that user walks into a multiuser mount.
>=20
> Jeff, is there an initial/earlier document that states exactly how
> a user can stash NTLM credentials?
>=20
> By NTLM credentials, it is meant that server/domain name/address
> and corrosponding password etc.?
>=20

Correct. The idea here is that this tool stashes a key (or keys) in the
session keyring with a name like:

    cifscreds:a:<IP Address>

=2E..or:

    cifscreds:d:<NT Domain Name>

=2E..that key has a payload that looks like this:

   <username>:<password>

=46or a multiuser mount, when a user walks into the mount for the first
time, the kernel can look for a key in the keyring for the right server=
,
or failing that, the right NT domain. It can then get username and
password info out of the payload to establish a session.

We could also use this to get credentials for the initial mount too,
but that use-case is less compelling.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
