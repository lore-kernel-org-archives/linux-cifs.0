From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: GSOC 2015 Aspirant for Improving SMB3 protocol improvements
Date: Wed, 4 Mar 2015 13:31:41 +0100
Message-ID: <20150304133141.35b0d72c@plati.site>
References: <CAK25hWMTkzSun5jD_8fLzBiROoD4h8oejZQPai9rwB8WqAENOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saket Sinha <saket.sinha89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK25hWMTkzSun5jD_8fLzBiROoD4h8oejZQPai9rwB8WqAENOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Saket Sinha,

Thanks for your interest...

On Wed, 4 Mar 2015 17:15:32 +0530, Saket Sinha wrote:

> Hi,
> 
> I am looking forward to paticipate in GSOC 2015 with Samba community for
> Improving SMB3 protocol improvements.
> 
> This is to discuss the idea further in order to build my understanding of
> the project.
> 
> The TODOs listed here show the following -
> 
>    1. Support for using multiple network interfaces at once under the same
>    mount (SMB3 multichannel)
>    2. Improved directory and metadata caching ("directory oplocks")
>    3. Improved failover in clustering environments ("persistent file
>    handles" and more generally SMB3 "continuous availability" support)
>    4. File copy offload (there are multiple server side copy mechanisms
>    possible with SMB3, T10 copy offload, SMB2/SMB3 "copy chunk" as well as an
>    older cifs mechanism "SMB Copy" that could be implemented, compared and
>    optimized).
>    5. HA availability improvements on server and/or client (the SMB3
>    "Witness protocol")
> 
>  I would like to be guided which one I should pick up to get started.

These tasks all relate to the Linux kernel CIFS/SMB client (cifs.ko), so
would be best answered on the cifs.ko mailing list (cc'ed). I'd suggest
only pursuing these tasks if you have a reasonably solid background in C
programming.

Cheers, David
