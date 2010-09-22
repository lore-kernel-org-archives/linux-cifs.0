From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v6 3/4] cifs NTLMv2/NTLMSSP define crypto hash functions
 and create and send keys needed for key exchange
Date: Tue, 21 Sep 2010 19:41:37 -0500
Message-ID: <AANLkTin16iCdo8X7e9e0G+6dn=hq=DRwRLTTNh8P08MM@mail.gmail.com>
References: <1284865355-16815-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100921105254.32574ba4@corrin.poochiereds.net>
	<AANLkTimqjBtVyB+xvtv5F5_qs333XiFQm+S=8Gh20+x2@mail.gmail.com>
	<20100921114049.75ab2ee8@corrin.poochiereds.net>
	<AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS-@mail.gmail.com>
	<20100921164257.3d67598f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100921164257.3d67598f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 21, 2010 at 6:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 21 Sep 2010 14:04:24 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> >
>> > Right. I'm just not sure why we need a separate flag attached to t=
he
>> > server struct for this. Why was the "first_time" mechanism not goo=
d
>> > enough here? I see no reason why that wouldn't have worked for NTL=
MSSP
>> > too.
>>
>> Jeff, I will investigate but at the first glance, it looks like
>> first_ses is per smb session
>> and not smb connection, not sure if that would be good enough for nt=
lmssp.
>>
>
> first_time is set by is_first_ses_reconnect(). The comment on that
> function says:
>
> =A0* Checks if this is the first smb session to be reconnected after
> =A0* the socket has been reestablished (so we know whether to use vc =
0).
> =A0* Called while holding the cifs_tcp_ses_lock, so do not block
>
> ...which isn't entirely true, since this works even when there hasn't
> been a reconnect. It just walks the list of sessions on a socket and
> sees if any of them are already established (that is, need_reconnect
> is false).
>
> So there is nominally a bug here -- sesInfoAlloc probably should set
> needs_reconnect to true. But since cifs_get_smb_ses doesn't stick the
> session on the server's list until after the session setup succeeds t=
he
> first time, it doesn't really cause any problems.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

If there is a way an smb connection would remain inspite of all set up
sessions gone, first_time will not work.  But should is_first_ses_recon=
nect
traverse the list under a lock?
