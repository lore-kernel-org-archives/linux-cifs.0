From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Tue, 19 Dec 2017 21:21:34 +0000
Message-ID: <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0@MWHPR21MB0846.namprd21.prod.outlook.com>
References: <20171219101327.2165797-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>  	depends on CIFS && INFINIBAND
> +	depends on CIFS=3Dm || INFINIBAND=3Dy

How about we change them to

        depends on CIFS=3Dm && INFINIBAND || CIFS=3Dy && INFINIBAND=3Dy

This makes it easy to read.
