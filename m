From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 00/12] cifscreds: cleanup and overhaul of cifscreds
 utility
Date: Sat, 17 Dec 2011 06:44:32 -0500
Message-ID: <20111217064432.1c881440@corrin.poochiereds.net>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
	<CADT32eKaX0Fd6iskcGtUTd0R5i+0SzMwAyjtubk-=RGZ6huB4w@mail.gmail.com>
	<20111215135901.01cfec1b@barsoom.rdu.redhat.com>
	<CADT32e+9stCUG+8dcxSh8VTu_5+gW0d_=3ZPqTgrGVd0J+qCcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+9stCUG+8dcxSh8VTu_5+gW0d_=3ZPqTgrGVd0J+qCcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 16 Dec 2011 09:48:30 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Dec 15, 2011 at 12:59 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Thu, 15 Dec 2011 12:20:15 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Thu, Dec 15, 2011 at 12:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
> >> > This patchset is a cleanup and overhaul of the cifscreds utility=
 that
> >> > lives in the cifs-utils tree today. Igor Druzhinin did a wonderf=
ul job
> >> > on this when he did the original code a couple of years ago, but=
 I did a
> >> > rather poor job at the time of communicating what we actually ne=
ed for
> >> > this tool to do. Mea culpa...
> >> >
> >> > This patch is a second pass at morphing it into a tool that's mo=
re like
> >> > what we need. I believe with this, I'll be able to roll some ker=
nel
> >> > patches that can use the stashed key for establishing sessions.
> >> >
> >> > I've made a few changes since the last set:
> >> >
> >> > - combine some of the earlier patches so it's a smaller set
> >> >
> >> > - I've dropped the patch to make key_search use keyctl_search. I=
'd still
> >> > =C2=A0like to do this differently, but for now it's not possible=
 to do so
> >> > =C2=A0and protect the key payload
> >> >
> >> > The idea here is that we want to be able to allow users to stash=
 their
> >> > NTLM credentials in the kernel, so that it's possible to establi=
sh a
> >> > session on the fly when that user walks into a multiuser mount.
> >>
> >> Jeff, is there an initial/earlier document that states exactly how
> >> a user can stash NTLM credentials?
> >>
> >> By NTLM credentials, it is meant that server/domain name/address
> >> and corrosponding password etc.?
> >>
> >
> > Correct. The idea here is that this tool stashes a key (or keys) in=
 the
> > session keyring with a name like:
> >
> > =C2=A0 =C2=A0cifscreds:a:<IP Address>
> >
> > ...or:
> >
> > =C2=A0 =C2=A0cifscreds:d:<NT Domain Name>
> >
> > ...that key has a payload that looks like this:
> >
> > =C2=A0 <username>:<password>
> >
> > For a multiuser mount, when a user walks into the mount for the fir=
st
> > time, the kernel can look for a key in the keyring for the right se=
rver,
> > or failing that, the right NT domain. It can then get username and
> > password info out of the payload to establish a session.
> >
> > We could also use this to get credentials for the initial mount too=
,
> > but that use-case is less compelling.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>=20
> Jeff, one of the concerns would be, how to sync up the pasword at the
> server and domain.  If the user password at the server changes,
> user must make corrosponding changes at the client machine?

Yes, at least prior to the next reconnect. Those are the perils of
password-based auth.

> Is there a provision to delete or update NTLM credential?

Yes, the cifscreds command has delete and update functionality.

> Also, if the same user can use multiple client machines to authentica=
te to the
> same server or domain, should every client machine have a copy of
> (the same) NTLM credentials stashed?  And then if password changes,
> user must remember to update NTLM credentials on each client machine!

Yes. It's somewhat similar to the situation with kerberos tickets. This
is just a way for users to securely store their username and password
so we can use it for multiuser mounts.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
