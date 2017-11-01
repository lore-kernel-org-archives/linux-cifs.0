From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v5 02/21] CIFS: SMBD: Establish SMB Direct connection
Date: Wed, 1 Nov 2017 10:19:01 -0700
Message-ID: <CAKywueQaUdUZaKX1_paQgPAorwRZ=Xv_7yyeFEgyTcYMrw3O-g@mail.gmail.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com> <20171018230920.21042-3-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171018230920.21042-3-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-10-18 16:09 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Add code to implement the core functions to establish a SMB Direct connection.
>
> 1. Establish an RDMA connection to SMB server.
> 2. Negotiate and setup SMB Direct protocol.
> 3. Implement idle connection timer and credit management.
>
> SMB Direct is enabled by setting CONFIG_CIFS_SMB_DIRECT.
>
> Add to Kconfig and Makefile to enable building SMB Direct.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/Kconfig     |    7 +
>  fs/cifs/Makefile    |    2 +
>  fs/cifs/smbdirect.c | 1576 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smbdirect.h |  265 +++++++++
>  4 files changed, 1850 insertions(+)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index f724361..cb7db8d 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -191,6 +191,13 @@ config CIFS_SMB311
>           This dialect includes improved security negotiation features.
>           If unsure, say N
>
> +config CIFS_SMB_DIRECT
> +       bool "SMB Direct support (Experimental)"
> +       depends on CIFS && INFINIBAND
> +       help
> +         Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
> +         SMB Direct allows transferring SMB packets over RDMA.
> +

Please add "If unsure, say N."

--
Best regards,
Pavel Shilovsky
