From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: async read patchset test results
Date: Wed, 19 Oct 2011 06:50:16 -0400
Message-ID: <20111019065016.0b3be0f1@tlielax.poochiereds.net>
References: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
	<20111013083151.55aa1cdf@barsoom.rdu.redhat.com>
	<CAKywueQg90k2FwRB+fJbmwq230p-DP-Zxtrc0+HP_gfieHxM6g@mail.gmail.com>
	<20111013133414.77f54658@barsoom.rdu.redhat.com>
	<CAKywueTjAwgmSpYeqX-iu6FhZbCiG5HTztDhNLWYFMkq3cmoBg@mail.gmail.com>
	<CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ@mail.gmail.com>
	<20111013140039.3200de5d@barsoom.rdu.redhat.com>
	<CAKywueSfX7sn46uPTz2L3WWWZgpNmEfECJDv70Lr-jjFvTXi+g@mail.gmail.com>
	<CAKywueQ20Jh139J4E0XfJ+ZTPsO8gDpXPHL2jZ3YBh72ajKAWA@mail.gmail.com>
	<20111014065508.2f4735d3@tlielax.poochiereds.net>
	<CAKywueT3d0dEf__rsoFZ1VK3s72CLXJjFQyGqDdTEe=6-hH-Yw@mail.gmail.com>
	<CAH2r5muvh_6K_Ou4Jz3Qwu6GNRn9ZJwQ5wLw71g=OfZwj+HVNQ@mail.gmail.com>
	<CAKywueQ2BAUYj-DKp3=H_t5ySTS=AgiY40t=_9rXw1hD-4MaxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ2BAUYj-DKp3=H_t5ySTS=AgiY40t=_9rXw1hD-4MaxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Oct 2011 00:59:50 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/10/19 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > On Tue, Oct 18, 2011 at 3:29 PM, Pavel Shilovsky <piastryyy@gmail.c=
om> wrote:
> >> 2011/10/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >>> On Fri, 14 Oct 2011 14:02:54 +0400
> >>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>>
> >>>> Today, I caught it once again and didn't noticed any reconnects =
(no cERRORs).
> >>>>
> >>>> It is surely not depends on Jeff's async read patchset, because =
I used
> >>>> my cifs-3.2-current branch.
> >>>>
> >>>> My branch consists of Steve's master + lockpatchset + smb2 patch=
es.
> >>>> From another hand, previously I caught it with Jeff's branch (wi=
thout
> >>>> lockpatchset and smb2 patches). So, that's why the problem is in
> >>>> existing cifs code now.
> >>>>
> >>>> FYI: I checked two files: "buggy" and original, and noticed that=
 the
> >>>> difference between them is located in one place - positions from
> >>>> 2014442 to 2014569 - 126 differences with two equal holes.
> >>>>
> >>>> So, 2014569 - 2014442 + 1 =3D 128 wrong bytes. Ideas?
> >>>>
> >>>
> >>> Good to know, thanks. I also tried reproducing this for a while l=
ast
> >>> night and was unable to...
> >>>
> >>> I used this script:
> >>>
> >>> -------------------------[snip]------------------------------
> >>> #!/bin/bash
> >>>
> >>> origfile=3D$1
> >>> destfile=3D$2
> >>>
> >>> origsum=3D`md5sum $origfile | cut -d' ' -f1`
> >>> i=3D0
> >>>
> >>> while true; do
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0echo $i
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $destfile $origfile.tmp
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D$origfile of=3D$destfile bs=3D=
100000
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ $? -ne 0 ]; then
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo "dd1 =
failed"
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit 1
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D$destfile of=3D$origfile.tmp b=
s=3D100000
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ $? -ne 0 ]; then
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo "dd2 =
failed"
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit 1
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0destsum=3D`md5sum $destfile | cut -d' =
' -f1`
> >>
> >> As you have already read $destfile to $origfile.tmp, there is no n=
eed
> >> to read it again - you only need to calculate md5sum of the
> >> origfile.tmp.
> >>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ "$origsum" !=3D "$destsum" ]; the=
n
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo "md5s=
ums don't match! orig=3D$origsum dest=3D$destsum"
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stat $orig=
file
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stat $dest=
file
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit 1
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0i=3D`expr $i + 1`
> >>> done
> >>>
> >>> -------------------------[snip]------------------------------
> >>>
> >>> I ran the above with the first arg set to a ~615M .iso file on lo=
cal
> >>> disk and the second to a file on a cifs mount.
> >>>
> >>> I ran it against my win2k8 host for several hours and it never fa=
iled.
> >>> I then tried running it against my Windows 7 home host (running o=
n
> >>> bare-metal) and it would run for a little while and would eventua=
lly
> >>> fail due to the server returning "out of memory" errors. Some of =
those
> >>> would occur on the NEGOTIATE call, so I chalk that up to a Win7 b=
ug.
> >>>
> >>> I never saw this mismatch, but I think we can try to infer someth=
ing
> >>> from the nature of the failures that Pavel saw...
> >>>
> >>> Since the file was apparently being written properly, the write p=
hase
> >>> seems like it worked correctly. The data all went into the cache,=
 and
> >>> then got flushed properly to the server.
> >>>
> >>> So, it seems likely that the problem is in the read phase of the =
test.
> >>> There are several possibilities:
> >>>
> >>> 1) we started out doing a cache read, but the cache was invalidat=
ed
> >>> partway through. "Something happened" and one of the reads got ma=
ngled.
> >>>
> >>> 2) the server sent us a corrupt read for some reason
> >>>
> >>> 3) lower level networking problem caused a corrupt read
> >>>
> >>> 4) generic memory corruption in the pagecache of some sort
> >>>
> >>> ...plus many others...
> >>>
> >>> The fact that only 127 bytes was corrupt is very odd. It would be
> >>> easier to understand if an entire page were bad, or an entire rsi=
ze
> >>> chunk.
> >>>
> >>> If you are able to reproduce this again, it might be helpful to s=
ee if
> >>> that's consistent. Try to nail down the nature of the corruption =
-- see
> >>> how much is different and where the different parts are. That may
> >>> help shed light on the problem...
> >>>
> >>> In any case, this will probably take some digging -- we should pr=
obably
> >>> open a bug at bugzilla.samba.org and start working on this there.
> >>> Pavel, would you mind doing that when you have time?
> >>>
> >>> Thanks,
> >>> --
> >>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>>
> >>
> >> So, after a closer investigating of the problem I figured out that=
:
> >>
> >> 1) It always reproduces after I boot the OS, load module, mount sh=
are
> >> and read the existing file.
> >>
> >> 2) Network traffics that are caught by wireshark on the server
> >> (Windows 7) and the client are different - I checked it and found =
the
> >> same difference in response packets for the area that is different=
 on
> >> orig and orig.tmp files (the response packet from the capture on t=
he
> >> server was true and the response packet from the capture on the cl=
ient
> >> was failed).
> >>
> >> 3) The different area is always 128 bytes bounded but appears in
> >> different places.
> >>
> >> 4) It doesn't depends on a maybe broken LAN cable - I used two
> >> different ones with the same results.
> >>
> >> So, I don't think that it's cifs module issue and there is no need=
 to
> >> open a bug on bugzilla.samba.org. It seems that it's the problem w=
ith
> >> the network driver or with the LAN card from my laptop.
> >>
> >> Make sense?
> >
> > Yes ... but it brings up the obvious question ... what happens if c=
ifs
> > signing is turned on?
> >
>=20
> I tried it - one "Unexpected SMB signature" message appears in dmesg.
>=20
> I found this code in cifs_check_receive:
> 503          /* convert the length into a more usable form */
> 504          if (server->sec_mode & (SECMODE_SIGN_REQUIRED |
> SECMODE_SIGN_ENABLED)) {
> 505                 struct kvec iov;
> 506
> 507                 iov.iov_base =3D mid->resp_buf;
> 508                 iov.iov_len =3D len;
> 509                 /* FIXME: add code to kill session */
> 510                 if (cifs_verify_signature(&iov, 1, server,
> 511
> mid->sequence_number + 1) !=3D 0)
> 512                         cERROR(1, "Unexpected SMB signature");
> 513         }
>=20
> So, now we don't do anything with if such a thing happens. My be we
> should follow the FIXME comment and kill the session?
>=20

Yes, it's been this way for a long time. MS-CIFS doesn't say that we
have to abort the connection however...

"If the signature received with the message does not match
the signature calculated, the message MUST be discarded, and no further
processing is done on it. The receiver MAY also terminate the
connection by disconnecting the underlying transport connection and
cleaning up any state associated with the connection."

At the very least we should use this to return an error back to the
caller and allow it to deal with that. Maybe then we could also abort
the connection after a certain number of signature check failures?

I'd hate to abort the socket just for one signature failure, especially
when we have apparent hiccups like this in the lower level networking.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
