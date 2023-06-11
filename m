Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D60C7EE23
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Jun 2023 08:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjFKIAd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Jun 2023 04:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjFKIAc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Jun 2023 04:00:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C7211C
        for <linux-cifs@vger.kernel.org>; Sun, 11 Jun 2023 01:00:29 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b1ba50e50bso35956101fa.1
        for <linux-cifs@vger.kernel.org>; Sun, 11 Jun 2023 01:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686470428; x=1689062428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4+7ZLof89euWXQCe0y8Gyh+W3jRVsPQ58am/9vkEfc=;
        b=KLBrp8MY30P7UaSCMs+tMObg9oMA4xrLXOCSV0UBYjKNgD4Xd+nLt1lf/e7k+0PTi8
         0st2akA/FLD/zOAqExieuiGBOXLjBL1OGcQ6IsaxW9dZf60fWzjXuOgfGexlxHBW9Rj6
         qO6omg35tWvPjRPRPyZHcSrYx48zv3FWnosjaqFiqwbhS2Ds+cGANNyjExKFqOSST64s
         F3NiQL69fBv0rdk45/DALmyN+fdHdSuZd0QDmaaft7k3YLOnjJDH9Tt4wKREIs6ZrYVc
         u49d93wLQtyFp1fY8N/g3j/E84prZ0i/+NJ171KgCZ0fUG+7IrFaW+1BT/PRDxb8bXY0
         Bvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686470428; x=1689062428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4+7ZLof89euWXQCe0y8Gyh+W3jRVsPQ58am/9vkEfc=;
        b=dIsc1Kg6Kw2N4m3Ww+WQD7IWz+AB3M97mIMbRdHjxQqsCsaLuucQp0xUEnG8TUaZMI
         1auerprbKYEmvhfOmEf7V1Jr0TOA8ZhDS4oAUBz5PWoS1oX4vc/7HgI4of5L1QMkZrLR
         1d0GjPnOmjdxl8Wf67crZatKoTqCBLdGJsxghtRPV6+WAC2wtVOgOTajM5Yhns7saXaB
         QhlGwvHPh4pZyXbpNJRxJML9feNFjnsrrttZSjj8wA3rbTEmvuMTXswZzrBi6g2GBXDd
         re4EkmyECtuYQOoHUyemfVySbDhHWMmUoDydgnnGBnFkJstZrCV/bZEN7TVKs1bWyz6i
         n07g==
X-Gm-Message-State: AC+VfDxCdnQyJSTtELoBb/TYkN5jABpLvSiyE3L7BvXx56MJZFOSIlYQ
        dlHYP7O3UO/MKBoY52d0Kft1hPg78PM7KxGbN7o=
X-Google-Smtp-Source: ACHHUZ4m+O/gg1Qv/7NYGFcWeHSgyRV18HG43Bpchp378NFTiPt6h5B1LOiRMu4JjoZGtwiF0HIlRmvASdW+mtOSXbc=
X-Received: by 2002:a2e:300f:0:b0:2b1:eb07:4d82 with SMTP id
 w15-20020a2e300f000000b002b1eb074d82mr1332837ljw.7.1686470427644; Sun, 11 Jun
 2023 01:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230609212959.32061-1-ematsumiya@suse.de>
In-Reply-To: <20230609212959.32061-1-ematsumiya@suse.de>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 11 Jun 2023 13:30:16 +0530
Message-ID: <CANT5p=pDUOqzP=jA0iJBDVmT+xU9diTOjZsjsT9RGejQ-31ygg@mail.gmail.com>
Subject: Re: [PATCH v2] smb/client: print "Unknown" instead of bogus link
 speed value
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jun 10, 2023 at 3:00=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> The virtio driver for Linux guests will not set a link speed to its
> paravirtualized NICs.  This will be seen as -1 in the ethernet layer, and
> when some servers (e.g. samba) fetches it, it's converted to an unsigned
> value (and multiplied by 1000 * 1000), so in client side we end up with:
>
> 1)      Speed: 4294967295000000 bps
>
> in DebugData.
>
> This patch introduces a helper that returns a speed string (in Mbps or
> Gbps) if interface speed is valid (>=3D SPEED_10 and <=3D SPEED_800000), =
or
> "Unknown" otherwise.
>
> The reason to not change the value in iface->speed is because we don't
> know the real speed of the HW backing the server NIC, so let's keep
> considering these as the fastest NICs available.
>
> Also print "Capabilities: None" when the interface doesn't support any.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> v2: remove dependency on CONFIG_PHYLIB by creating our own helper
>
>  fs/smb/client/cifs_debug.c | 47 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 46 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 5034b862cec2..c5d9579e1861 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/proc_fs.h>
>  #include <linux/uaccess.h>
> +#include <uapi/linux/ethtool.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> @@ -146,18 +147,62 @@ cifs_dump_channel(struct seq_file *m, int i, struct=
 cifs_chan *chan)
>                    atomic_read(&server->num_waiters));
>  }
>
> +static inline const char *smb_speed_to_str(size_t bps)
> +{
> +       size_t mbps =3D bps / 1000 / 1000;
> +
> +       switch (mbps) {
> +       case SPEED_10:
> +               return "10Mbps";
> +       case SPEED_100:
> +               return "100Mbps";
> +       case SPEED_1000:
> +               return "1Gbps";
> +       case SPEED_2500:
> +               return "2.5Gbps";
> +       case SPEED_5000:
> +               return "5Gbps";
> +       case SPEED_10000:
> +               return "10Gbps";
> +       case SPEED_14000:
> +               return "14Gbps";
> +       case SPEED_20000:
> +               return "20Gbps";
> +       case SPEED_25000:
> +               return "25Gbps";
> +       case SPEED_40000:
> +               return "40Gbps";
> +       case SPEED_50000:
> +               return "50Gbps";
> +       case SPEED_56000:
> +               return "56Gbps";
> +       case SPEED_100000:
> +               return "100Gbps";
> +       case SPEED_200000:
> +               return "200Gbps";
> +       case SPEED_400000:
> +               return "400Gbps";
> +       case SPEED_800000:
> +               return "800Gbps";
> +       default:
> +               return "Unknown";
> +       }
> +}
> +
>  static void
>  cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
>  {
>         struct sockaddr_in *ipv4 =3D (struct sockaddr_in *)&iface->sockad=
dr;
>         struct sockaddr_in6 *ipv6 =3D (struct sockaddr_in6 *)&iface->sock=
addr;
>
> -       seq_printf(m, "\tSpeed: %zu bps\n", iface->speed);
> +       seq_printf(m, "\tSpeed: %s\n", smb_speed_to_str(iface->speed));
>         seq_puts(m, "\t\tCapabilities: ");
>         if (iface->rdma_capable)
>                 seq_puts(m, "rdma ");
>         if (iface->rss_capable)
>                 seq_puts(m, "rss ");
> +       if (!iface->rdma_capable && !iface->rss_capable)
> +               seq_puts(m, "None");
>         seq_putc(m, '\n');
>         if (iface->sockaddr.ss_family =3D=3D AF_INET)
>                 seq_printf(m, "\t\tIPv4: %pI4\n", &ipv4->sin_addr);
> --
> 2.40.1
>
Looks good to me.

--=20
Regards,
Shyam
