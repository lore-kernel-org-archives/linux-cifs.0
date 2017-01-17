From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: US-Cert recommends disabling SMB1
Date: Tue, 17 Jan 2017 11:14:12 -0800
Message-ID: <587E6D04.8010803@tlinx.org>
References: <1484670992.21675.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484670992.21675.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sachin Prabhu wrote:
> The following advisory was released by US-CERT.
>
> https://www.us-cert.gov/ncas/current-activity/2017/01/16/SMB-Security-B
> est-Practices
>   

Interesting since the KB articles they point out only tell how to disable
SMB SMB2 or SMB3, but not why you would do so.

Note, I have had to use SMB(1) on Windows7SP1 at times when I couldn't get
SMB2 to work.  Could the US-CERT people explain what the risk is in
using SMB1 on a closed (not exposed to the internet) network?

FWIW, I am running SMB2 now...

Sure wish I knew how to optimize it, as I have gotten 400-600MB/s
in past testing (don't know what SMB level it was), but am now only
getting ~ 200MB/s on SMB2.  SMB1 was in the low 100's for throughput.
(between Win7SP1 client and Samba-on-linux server).
