From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v6 3/4] cifs NTLMv2/NTLMSSP define crypto hash functions
 and create and send keys needed for key exchange
Date: Wed, 22 Sep 2010 15:42:16 -0500
Message-ID: <AANLkTinU50DqmH_C74vS_N_U-EU9RN4DMtSMA9osA6v2@mail.gmail.com>
References: <1284865355-16815-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100921105254.32574ba4@corrin.poochiereds.net>
	<AANLkTimqjBtVyB+xvtv5F5_qs333XiFQm+S=8Gh20+x2@mail.gmail.com>
	<20100921114049.75ab2ee8@corrin.poochiereds.net>
	<AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS-@mail.gmail.com>
	<20100921164257.3d67598f@corrin.poochiereds.net>
	<AANLkTimOJLuBxDQHPZJAUxR3ieeErzUyzXwSP=VPO-+_@mail.gmail.com>
	<20100921200715.2a2d0b9e@corrin.poochiereds.net>
	<AANLkTinpO_pNz5JQTx9mRAE+HSaWeasMtmTzM6+OfE4Z@mail.gmail.com>
	<20100921204034.5cb9eca5@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100921204034.5cb9eca5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 21, 2010 at 10:40 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Tue, 21 Sep 2010 22:20:21 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Sep 21, 2010 at 10:07 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>> > On Tue, 21 Sep 2010 21:57:44 -0500
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Tue, Sep 21, 2010 at 6:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
>> >> > On Tue, 21 Sep 2010 14:04:24 -0500
>> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> >
>> >> >> > Right. I'm just not sure why we need a separate flag attache=
d to the
>> >> >> > server struct for this. Why was the "first_time" mechanism n=
ot good
>> >> >> > enough here? I see no reason why that wouldn't have worked f=
or NTLMSSP
>> >> >> > too.
>> >> >>
>> >> >> Jeff, I will investigate but at the first glance, it looks lik=
e
>> >> >> first_ses is per smb session
>> >> >> and not smb connection, not sure if that would be good enough =
for ntlmssp.
>> >> >>
>> >> >
>> >> > first_time is set by is_first_ses_reconnect(). The comment on t=
hat
>> >> > function says:
>> >> >
>> >> > =A0* Checks if this is the first smb session to be reconnected =
after
>> >> > =A0* the socket has been reestablished (so we know whether to u=
se vc 0).
>> >> > =A0* Called while holding the cifs_tcp_ses_lock, so do not bloc=
k
>> >> >
>> >> > ...which isn't entirely true, since this works even when there =
hasn't
>> >> > been a reconnect. It just walks the list of sessions on a socke=
t and
>> >> > sees if any of them are already established (that is, need_reco=
nnect
>> >> > is false).
>> >> >
>> >> > So there is nominally a bug here -- sesInfoAlloc probably shoul=
d set
>> >> > needs_reconnect to true. But since cifs_get_smb_ses doesn't sti=
ck the
>> >> > session on the server's list until after the session setup succ=
eeds the
>> >> > first time, it doesn't really cause any problems.
>> >> >
>> >> > --
>> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> >> >
>> >>
>> >> We probably ought to keep first_time or cphready per type of auth=
 mech
>> >> since it is possible to have multiple smb sessions on the same co=
nnection using
>> >> various kinds of authentication mechanisms.
>> >>
>> >
>> > Ok, but only one of them gets to set the actual session_key. The s=
ocket
>> > is a "shared" resource of sorts and we need something that indicat=
es
>> > which session has the "right of way" to set the session_key. The t=
hing
>> > with traffic lights is that they only work if everyone agrees on w=
hich
>> > ones to use. ;)
>> >
>>
>> I am not sure traffic light analogy will work. =A0I think signing fo=
r session
>> with sec=3Dntlmsspi will fail if sec=3Dntlmv2i happend to be very fi=
rst session
>> on that smb connect and has set up the session key.
>> The keys are different, stored in different locations, and the schem=
e is
>> different i.e. the key sizes that go in the signing are different si=
zes.
>>
>
> Do you know this for a fact? My understanding is different than this.
> AFAIU, the session_key is simply set by the first SESSION_SETUP
> performed on the socket. If the first one uses plain NTLM and then a
> later one uses krb5, then the socket uses the key from the NTLM setup
> for signing even if the krb5 session had a bigger key.
>
> Now, in point of fact, the client doesn't currently mix sectypes on a
> socket, so the argument is somewhat moot. If there are races with the
> first_time flag however (and I think that you're correct that there
> are), then they should be fixed.
>
>> > Your previous email sounded convincing that there is a potential r=
ace
>> > there. I think you should work through the implications of that an=
d
>> > come up with a race-free scheme that fixes this. Don't just do it =
for
>> > NTLMSSP though -- fix it for all the sectypes.
>> >
>>
>> The scope of this patch was deemed ntlmv2 within NTLMSSP
>> authentication and signing.
>> I do not have a setup for kerberos testing on Samba as well as Windo=
ws
>> server as of now.
>>
>
> That's fine, a separate patch will do. My suggestion would be to do a=
n
> initial cleanup patch that eliminates the first_time flag and switche=
s
> it to use your new scheme or something similarly non-racy, and then t=
o
> respin patches 3 and 4 in your set as a new set on top of that.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Is this correct? Every auth type gets its own smb connection (in match
security)?
We probably do not need that check (and functionality).
