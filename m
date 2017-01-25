From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH 0/3] cifs: Better dependencies
Date: Wed, 25 Jan 2017 11:26:04 -0800
Message-ID: <CAKywueQdAQ004cy2gGQTeDCeHwoT70Wug5LUgenANqGrmi9ziw@mail.gmail.com>
References: <20170125160639.255cd58e@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170125160639.255cd58e@endymion>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2017-01-25 7:06 GMT-08:00 Jean Delvare <jdelvare@suse.de>:
> Hi all,
>
> This is my attempt to fix and improve the dependencies of cifs.
>
> [PATCH 1/3] cifs: Simplify SMB2 and SMB311 dependencies
> [PATCH 2/3] cifs: Only select the required crypto modules
> [PATCH 3/3] cifs: Add soft dependencies
>
> I already sent this patch series one year ago, but did not get any
> reply, so I am trying again.
>
> Thanks,
> --
> Jean Delvare
> SUSE L3 Support
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

-- 
Best regards,
Pavel Shilovsky
