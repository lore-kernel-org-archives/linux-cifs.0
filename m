From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: cifs tree updated to back out crypto/ntlmv2/ntlmssp change to
 2.6.37 - but now has the cifsd fixes
Date: Thu, 09 Sep 2010 17:31:31 +0530
Message-ID: <4C88CC9B.9040904@suse.de>
References: <AANLkTimraXF9gVC-o5qb2mfDfrq6=9-CTtyGeew27ne6@mail.gmail.com> <20100909075242.11d03854@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100909075242.11d03854-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/09/2010 05:22 PM, Jeff Layton wrote:
> On Wed, 8 Sep 2010 16:25:09 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> CIFS tree updated to back out the crypto/ntlmv2/ntlmssp change
>> (included patch 2/8 because it was reviewed and independent).   Added
>> to the cifs tree the fixes to prevent premature exit to cifsd and to
>> prevent the possibly ip address memory corruption.
>>
>> -- 
>> Thanks,
>>
> 
> Looks good to me.
> 
> BTW, when you send the pull request to Linus, could you also cc
> linux-cifs? It's helpful to know when you send these out so that we know
> to keep a closer eye on mainline.
> 

Yes, please. It would help to know when pull request is being sent.

Thanks,

-- 
Suresh Jayaraman
