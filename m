From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] CIFS: do not send invalid input buffer on QUERY_INFO requests
Date: Wed, 18 Oct 2017 16:50:22 +0200
Message-ID: <mpspo9ktsr5.fsf@aaptelpc.suse.de>
References: <mpsa80ruowd.fsf@aaptelpc.suse.de> <20171017124717.25955-1-aaptel@suse.com> <f87e7391-b2f0-feaf-3489-686d0368fe64@lal.in2p3.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f87e7391-b2f0-feaf-3489-686d0368fe64-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org> writes:
> Just tried out this patch, and the CIFS module does indeed produce 
> well-formed GetInfo requests now (according to Wireshark's definition at 
> least, didn't check myself).
>
> However, the server will still reject the request with a 
> STATUS_NOT_SUPPORTED error, suggesting that Steve's interpretation was 
> the right one: this is likely a server-side bug.

Yes. As Steve suggested as a workaround, we could try to use a less
detailed information level if FullInfo fails. Is it worth doing for a
single old NetApp server?

As for the offset and extra byte in QUERY_INFO I guess having the length
set to 0 makes it ok... I've sent a couple of patches to Wireshark to
fix the packet parsing. It now accepts the empty filename in CREATE (no
more "[unknown]"), which enables the proper parsing of the unknown
field.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
