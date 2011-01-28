From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix length checks in checkSMB (try #2)
Date: Fri, 28 Jan 2011 13:38:48 -0600
Message-ID: <AANLkTi=vXXptjPU1N+M3jmM-xL-wrUJm-hK+EHThHi6c@mail.gmail.com>
References: <AANLkTimbuWJWAwbmCVVhFub4Y_Yg-QVXoqr96rGhqHd+@mail.gmail.com>
	<1296217463-4584-1-git-send-email-jlayton@redhat.com>
	<AANLkTimaH5hRX3HyHBrbXf-wP3ZaPQ2378-qsh7fi6Am@mail.gmail.com>
	<20110128142821.75a369be@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110128142821.75a369be-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 28, 2011 at 1:28 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 28 Jan 2011 12:53:52 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Jan 28, 2011 at 6:24 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > The cERROR message in checkSMB when the calculated length doesn't =
match
>> > the RFC1001 length is incorrect in many cases. It always says that=
 the
>> > RFC1001 length is bigger than the SMB, even when it's actually the
>> > reverse.
>> >
>> > Fix the error message to say the reverse of what it does now when =
the
>> > SMB length goes beyond the end of the received data. Also, clarify=
 the
>> > error message when the RFC length is too big. Finally, clarify the
>> > comments to show that the 512 byte limit on extra data at the end =
of
>> > the packet is arbitrary.
>>
>> Do we have any data to indicate that other servers send incorrect
>> rfc1001 lengths larger than 512 bytes? =A0In eight years of test eve=
nts, I
>> have seen only a few responses (from Windows and NetApp IIRC) where =
the
>> length was slightly too long. =A0The 512 byte was chosen because it
>> was large enough to pass testing to all servers we had seen,
>> allowing us to workaround problematic responses from real servers
>> while still limiting the probability that "randomly generated" frame=
s
>> with incorrect lengths would pass validation checks and be
>> processed.
>>
>
> I'm not aware of any. My reason for proposing the patch to remove the
> +512b limitation was simply that it didn't seem necessary to impose
> such a limitation. The lengths all fit within what we had received so
> ignoring any extra junk tacked on the end is harmless.
>
>> If we have data on a byte range lock or find first response from Win=
dows
>> generating more than 512 bytes of junk then we should remove the
>> check.
>>
>> The theory proposed to explain why we see incorrect frame lengths
>> from some servers was that due to rounding or due to RFC1001 length
>> being calculated before it was determined whether the frame would re=
turn
>> an smb error (e.g. access control error) error - the length could be=
 off
>> by up to sizeof of one t2 infolevel =A0Length could be off up to the=
 sizeof of
>> the fixed portion of one transact2 infolevel (all of which are less
>> than 512 bytes)
>> if the server e.g. decides to include one fewer findfirst entry in a=
 response,
>> or if a server fills in =A0t2 query file info data, then gets an acc=
ess error,
>> leaving the data, but adjusting the smb length, leaving the incorrec=
t
>> rfc1001 len.
>> In all of the theorized and observed (at test events)
>> cases, the server would never be off by more than sizeof largest tra=
nsact2
>> infolevel.
>>
>> Also note that removing this check makes it harder for new server
>> manufacturers to catch serious bugs in their products as the client
>> no longer will do validity checking for them. =A0Speaking from past =
experience
>> it is more painful to debug a server mixing up the wrong type of res=
ponse
>> for a request if validity checking is overly relaxed.
>>
>> Does anyone have data on an existing server in the field that sends
>> anything off by more than
>> 512 bytes (the most I remember a server being off was about 100 or s=
o bytes)
>> in frame length?
>>
>
> I give up. The latest patch (try #2) doesn't remove any checks. It ju=
st
> clarifies the cERROR printk's and the comments.

Patch if fine and mergeable.   I don't object to the error cleanup,
but I thought
you were implying that you had data on two cases where servers
would still fail with such a check.



--=20
Thanks,

Steve
