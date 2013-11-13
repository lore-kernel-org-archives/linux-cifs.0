From: Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH linux-next] cifs: Use data structures to compute NTLMv2
 response offsets
Date: Tue, 12 Nov 2013 17:03:11 -0800
Message-ID: <5282CFCF.2020100@canonical.com>
References: <1383867657-110399-1-git-send-email-tim.gardner@canonical.com> <CADT32e+ed9EzAb2jraHxmB0CF5AMUQ7XYiuEfH-FOcy7XqqmNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+ed9EzAb2jraHxmB0CF5AMUQ7XYiuEfH-FOcy7XqqmNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/08/2013 01:19 PM, Shirish Pargaonkar wrote:
> Looks correct.  You may want to verify that the code works fine for both
> sec=ntlmssp/ntlmsspi and sec=ntlmv2/ntlmv2i mount options.
> 
> Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
> 

These are the mount attempt results using a stock 3.12 kernel built with
the Ubuntu Trusty config. I am not well versed enough in the various
security mechanisms to know what should work.

mount sec=ntlmssp on WinPro8 success
mount sec=ntlmsspi on WinPro8 failure
mount sec=ntlmv2 on WinPro8 failure
mount sec=ntlmv2i on WinPro8 failure
mount sec=ntlmssp on iOS-10.8 success
mount sec=ntlmsspi on iOS-10.8 success
mount sec=ntlmv2 on iOS-10.8 failure
mount sec=ntlmv2i on iOS-10.8 failure
mount sec=ntlmssp on Linux-3.2 success
mount sec=ntlmsspi on Linux-3.2 failure
mount sec=ntlmv2 on Linux-3.2 success
mount sec=ntlmv2i on Linux-3.2 failure

The mount parameters used were '-o
noserverino,nounix,user=test,pass=test'. For example,

sudo mount -t cifs //10.0.0.182/test /tmp/mnt -o
noserverino,nounix,user=test,pass=test,sec=ntlmssp

The patched kernel produced identical results.

rtg
-- 
Tim Gardner tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
