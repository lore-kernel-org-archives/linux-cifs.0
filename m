From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] SMB2 brlocks, leases and multicredit io
Date: Tue, 21 Aug 2012 18:08:40 +0400
Message-ID: <CAKywueRsBYRyCFMjWEhtTS5GP2PWqv4Y_W49q+Q+egBo-xCY3w@mail.gmail.com>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
	<k0vjao$hck$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <k0vjao$hck$1@ger.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/8/21 Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Hi Pavel,
>
>> This is a patchset that includes the rest of SMB2 changes: brlocks, leases and multicredit io.
>>
>> The changes are applied on top of Jeff's recent patchset and can be found here:
>> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev-cork
>>
>> Pavel Shilovsky (10):
>>   CIFS: Improve byte-range locks handling
>>   CIFS: Handle SMB2 lock flags
>>   CIFS: Move brlock code to ops struct
>>   CIFS: Add brlock support for SMB2
>>   CIFS: Request SMB2.1 leases
>>   CIFS: Add SMB2.1 lease break support
>>   CIFS: Fix cache coherency for read oplock case
>>   CIFS: Make use of multicredit write for SMB2
>>   CIFS: Make use of multicredit reads for SMB2
>
> Leases and multi-credit support are negotiated features in the capabilities
> bits of the server. You should not rely on the dialect before you use them,
> as there're servers which support SMB 2.1, but do not support leases or
> multi-credit.

Ok, thanks - will fix this.

>
> I think smb2_get_credit_size() should return 1 if the value in the header
> is 0.

It brings no problem because CreditCharge value is set to 1 in header
assemble (and can be rewritten further in async read and write
codepath) - so, get_credit_size gets at least 1.

>
> Regarding
> +       /* random value */
> +       req->ClientGUID[0] = req->ClientGUID[3] = req->ClientGUID[7] = 7;
>
> I think you should use a random value here as the server uses this field
> to detect if requests come from the same client. This should be a global
> in the cifs.ok, which can change on reboot/module reload.
>

Yes, this is a good point. I just set it this way temporarily (for
testing purpose) and forgot to replace with random bytes. Thanks.


-- 
Best regards,
Pavel Shilovsky.
