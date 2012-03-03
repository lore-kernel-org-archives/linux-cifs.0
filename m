From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Sat, 3 Mar 2012 12:35:50 +0400
Message-ID: <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This is going to be more complicated than it seems.
>
> Apparently (according to Chris), Windows will often allow mapmpx simu=
ltaneous
> requests per process for various handle based requests. =A0 In additi=
on according
> to JRA, Samba server does not care if you go beyond maxmpx (and there=
 is
> a big performance advantage of that). =A0 On the other hand - if the =
server
> sets maxmpx to less than 10, these kind of changes probably make sens=
e
> (those servers are probably broken otherwise), but for normal servers
> this will end up restricting more than windows (for more than than th=
e
> maxmpx per pid). =A0 Generally, for servers like Samba that support
> simultaneous requests reasonably we have to be careful about killing
> performance especially now that with Jeff's async reads and writes
> we will frequently get up to 50 (and should probably make it easier
> to have more than 50 to servers like Samba).
>
> Quoting JRA and Volker - "You should be able to queue
> thousands of simultaneous requests from one client to Samba"
> (as long as the client doesn't time out. =A0The server keeps
> responding to the earlier requests, so with our client timeout
> code weshould be fine).
>

If Samba supports more than 50 requests on fly why it doens't set
MaxMpx count value appropriately (higher that 50). If some servers
respect this value, some - not, why this value needs anyway? I really
think that if it exists in the spec we must follow it's logic -
support all servers that follow the CIFS/SMB spec.

=46rom another hand, we won't kill the nowdays performance if we
substract only 1 slot for echos and 1 slot for oplocks from maxmpx
value (we have 48 for Samba anyway). But it helps us to make the code
more common and easily shareble between existing cifs code and new
smb2 one (for smb2 we should reserve these 2 slots too).

I really think we shouldn't fix all the problems with one patch. This
patch doesn't make things worse but better: it solves the problem with
3rd party servers and doesn't make the performance worse (there is no
much difference between 48 and 50 simultaneous requests for io
operations).

While we can change the behavior for some special cases (Samba,
Windows) later to make them faster, etc, I think we shouldn't stop on
the current patch - it fixes the existing bug and it is the essential
step we should do before SMB2 comes to the tree.

--=20
Best regards,
Pavel Shilovsky.
