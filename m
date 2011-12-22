From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Thu, 22 Dec 2011 08:33:49 -0600
Message-ID: <CADT32e+NsYc2FcRWUz=Y0O+nMj1Jtnam5OND+EzoOXErt-HDcQ@mail.gmail.com>
References: <4ED2FD48.7060108@gmail.com>
	<CADT32e+RMW_oT=g9OMpy29OHQ731Du7_XaT=xOeMyYGWOofAEg@mail.gmail.com>
	<jbit2d$ikm$1@dough.gmane.org>
	<20111222070259.2c5de94e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111222070259.2c5de94e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 22, 2011 at 6:02 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 05 Dec 2011 16:55:42 +0000
> jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On 05/12/11 16:00, Shirish Pargaonkar wrote:
>> >>
>> >> the following command works from my slackware system:
>> >> =A0 mount.cifs //server/share /mnt -o guest
>> >
>> > Would be interesting to compare the tcpdump/wireshark trace
>> > for a successful anonymous login from slackware but failing
>> > anonymous login from a xubuntu box.
>> >
>>
>> ok, I've attached file generated on slackware, only difference to th=
e
>> command above is the mountpoint (/mnt/store).
>>
>> the xubuntu one, same tcpdump command-line and mount.cifs invokation=
,
>> was posted on 2nd Dec.
>>
>> >
>> > Is there something setup in the stanza of this share on the Samba
>> > server that is specific to Xubuntu machine/address?
>> >
>>
>> not to my knowledge, NAS has never been set-up in this sense, all
>> defaults. =A0on the two respective clients I use exact same smb.conf=
's
>> (except hostname) but in any case, mount.cifs ignores smb.conf,
>> according to its man page.
>
> Ok, I had a look at both captures. The main difference (as Shirish
> pointed out earlier) is that the server is requesting share mode
> security in some cases and user mode in another.
>
> It does this early on, during the NEGOTIATE PROTOCOL phase, so the us=
er
> you're authenticating as and the actual tree you're connecting to
> probably don't matter here.
>
> What does matter is the info that the client is sending in the
> NEGOTIATE PROTOCOL request. There's some key difference here that's
> causing the server to behave differently.
>
> The main differences I can see are:
>
> 1/ The older client (slackware) doesn't set the NT error codes bit in
> =A0 flags2.
>
> 2/ The older client sends a smaller list of dialects than the newer o=
ne
>
> ...and that's really it as far as I can tell. What might be interesti=
ng
> is a test patch that makes the negprot request from the newer client
> look like the older one.
>
> Either way, this is almost certainly a server bug and it's doubtful w=
e
> can reasonably fix this from the client side.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Jeff, Thanks.  This is what I had sent to jr earlier...

What is strange is, smbclient on the xubuntu box receiving a negprot re=
sponse
with share level security but cifs client on the same xubuntu box
receiving a negprot response with user level security.

Not sure whether the Samba server on this NAS box is making that distin=
ction
in the negprot response based on either the list of the dialects receiv=
ed
in negprot request or some entry/entries in /etc/samba/smb.conf or
something else.

So if jr builds and uses the cifs module on xubuntu by removing the
config option  CONFIG_CIFS_WEAK_PW_HASH, it will send the
same dialects as the cifs module from slackware is sending in the
negrpot request, and that might affect the negprot response from
the Samba server to the cifs client on xubuntu.

jr is also trying to see if he can mount a share from Windows box
so that will tell whether there is any bug in authentication code
changes between cifs client version on slackware (1.48 or 1.46 I think)
and cifs client version on xubuntu (1.76 I think), if at all.

Regards,

Shirish
