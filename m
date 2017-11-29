From: Matthias Urlichs <matthias-+qxcz+fHsVSELgA04lAiVw@public.gmane.org>
Subject: reconnection loop
Date: Wed, 29 Nov 2017 13:14:09 +0100
Message-ID: <dd42aeea-3097-b013-fb9b-633df41ec49e@urlichs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: de-CH
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am observing a reconnect loop with samba4.

The problem is that the kernel opens the connection and initially sends
an SMBecho packet. Samba4 however only accepts SMBnegprot as the first
packet, thus it immediately closes the connection. The kernel
immediately tries again.

Regardless of whether it's acceptable to initially send an echo packet:
shouldn't the kernel do some sort of rudimentary back-off? as it is I
have logged 15 million reconnections since yesterday …

-- 
-- Matthias Urlichs
