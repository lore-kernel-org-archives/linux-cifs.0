From: Peter Flood <info-O17Z5ZPWbgxgJw1g6a66pQ@public.gmane.org>
Subject: Re: [Samba] Read offline attribute
Date: Wed, 11 Jun 2014 11:20:59 +0100
Message-ID: <53982D8B.6080701@whywouldwe.com>
References: <53971D84.1020806@whywouldwe.com>	<53971ECD.4070301@whywouldwe.com> <20140610173250.1769b200@plati.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140610173250.1769b200-k1XZOR0ctBLN0uC3ymp8PA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi David

Thanks, works.

Peter

On 10/06/2014 16:32, David Disseldorp wrote:
> Hi Peter,
>
> On Tue, 10 Jun 2014 16:05:49 +0100, Peter Flood wrote:
>
>> I want to read the 'offline' extended attribute on files on a windows
>> share mounted on a linux host, is it possible to get this info?
> The Linux CIFS client doesn't currently offer such support. However,
> the offline attribute can be checked using smbclient via the allinfo
> command. Offline files will carry an 'O' in the attributes field.
>
> Cheers, David
