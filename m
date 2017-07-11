From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: Check for timeout on Negotiate stage
Date: Tue, 11 Jul 2017 14:18:07 +0200
Message-ID: <mpsshi3f9q8.fsf@aaptelpc.suse.de>
References: <20170711104439.23254-1-scabrero@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Samuel Cabrero <scabrero-l3A5Bk7waGM@public.gmane.org>
To: Samuel Cabrero <scabrero-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170711104439.23254-1-scabrero-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Samuel Cabrero <scabrero-l3A5Bk7waGM@public.gmane.org> writes:
> Some servers seem to accept connections while booting but never send
> the SMBNegotiate response neither close the connection, causing all
> processes accessing the share hang on uninterruptible sleep state.
>
> This happens when the cifs_demultiplex_thread detects the server is
> unresponsive so releases the socket and start trying to reconnect.
> At some point, the faulty server will accept the socket and the TCP
> status will be set to NeedNegotiate. The first issued command accessing
> the share will start the negotiation (pid 5828 below), but the response
> will never arrive so other commands will be blocked waiting on the mutex
> (pid 55352).

To add to this, the bug happens against Windows Server 2012 R2 and it's
a bit tricky to reproduce. As Samuel said, the server has to be booted
long enough to have the tcp stack up but not long enough to have the SMB
stack fully ready (as it is unresponsive to the nego request). Could be
a bug on MS side (or some third party installed software?) but I think
if it results in an avoidable hang on our side it should be fixed.

Reviewed-by: Aurélien Aptel <aaptel-l3A5Bk7waGM@public.gmane.org>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
