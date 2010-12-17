From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs: move "ntlmssp" and "local_leases" options out
 of experimental code
Date: Fri, 17 Dec 2010 10:33:02 -0600
Message-ID: <AANLkTikSOy-UHrOQxpACBrA9=5G+H8yDxVGDt_B443LJ@mail.gmail.com>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com>
	<1291820625-20907-3-git-send-email-jlayton@redhat.com>
	<4D0B81B8.6090603@suse.de>
	<AANLkTikcnfDE=TwQ4uHWxQPOkPvuJhAkROT6fuDksOSs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikcnfDE=TwQ4uHWxQPOkPvuJhAkROT6fuDksOSs-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I would like this patch in soon - as was noted it simplifies
build/testing to make these options non-experimental and we need to
have at least an informal schedule for moving code out of experimental
when no bugs found (over a few release cycles)

Shirish,
Can you point me to any NTLMSSP fixes you think are necessary?

On Fri, Dec 17, 2010 at 9:43 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Dec 17, 2010 at 9:28 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org=
> wrote:
>> On 12/08/2010 08:33 PM, Jeff Layton wrote:
>>> I see no real need to leave these sorts of options under an
>>> EXPERIMENTAL ifdef. Since you need a mount option to turn this code
>>> on, that only blows out the testing matrix.
>>>
>>> local_leases has been under the EXPERIMENTAL tag for some time, but
>>> it's only the mount option that's under this label. Move it out
>>> from under this tag.
>>>
>>> The NTLMSSP code is also under EXPERIMENTAL, but it needs a mount
>>> option to turn it on, and in the future any distro will reasonably
>>> want this enabled. Go ahead and move it out from under the
>>> EXPERIMENTAL tag.
>>>
>>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>> =A0fs/cifs/cifssmb.c | =A0 =A05 +--
>>> =A0fs/cifs/connect.c | =A0 =A04 --
>>> =A0fs/cifs/sess.c =A0 =A0| =A0103 ++++++++++++++++++++++++---------=
--------------------
>>> =A03 files changed, 48 insertions(+), 64 deletions(-)
>>
>> Moving local_leases out sounds fine to me. While I agree that NTLMSS=
P is
>> something everyone wants moving ahead, I'm not sure whether there ar=
e
>> currently any known/open issues with specific Servers.
>> Shirish?
>>
>> Assuming there are none,
>
> Yes. There was one issue in NTLMSSP and it has been fixed and
> the patch hasbeen posted, discussed, and ack'ed by Jeff Layton.
> I am not aware of any other issues at this time that break
> NTLMSSP authentication.
>
> Only change we would want to see is reconciliation of flags sent
> by client in type 1 (negotiation) exchange packet and flags sent
> by server in type 2 (challenge) exchange packet and resultant
> flags and data according to those flags sent by client in
> type 3 (authentication) exchange packet.
>
>>
>> Acked-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>
>



--=20
Thanks,

Steve
