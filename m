From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 00/10] SMB2 brlocks, leases and multicredit io
Date: Tue, 21 Aug 2012 11:10:48 +0200
Message-ID: <k0vjao$hck$1@ger.gmane.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

> This is a patchset that includes the rest of SMB2 changes: brlocks, leases and multicredit io.
> 
> The changes are applied on top of Jeff's recent patchset and can be found here:
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev-cork
> 
> Pavel Shilovsky (10):
>   CIFS: Improve byte-range locks handling
>   CIFS: Handle SMB2 lock flags
>   CIFS: Move brlock code to ops struct
>   CIFS: Add brlock support for SMB2
>   CIFS: Request SMB2.1 leases
>   CIFS: Add SMB2.1 lease break support
>   CIFS: Fix cache coherency for read oplock case
>   CIFS: Make use of multicredit write for SMB2
>   CIFS: Make use of multicredit reads for SMB2

Leases and multi-credit support are negotiated features in the capabilities
bits of the server. You should not rely on the dialect before you use them,
as there're servers which support SMB 2.1, but do not support leases or
multi-credit.

I think smb2_get_credit_size() should return 1 if the value in the header
is 0.

Regarding
+       /* random value */
+       req->ClientGUID[0] = req->ClientGUID[3] = req->ClientGUID[7] = 7;

I think you should use a random value here as the server uses this field
to detect if requests come from the same client. This should be a global
in the cifs.ok, which can change on reboot/module reload.

metze
