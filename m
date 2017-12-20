From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Wed, 20 Dec 2017 09:17:43 +0100
Message-ID: <CAK8P3a17fAbUAsG0xSGx1jfsSvKbx_W+VKZBFnwmrdw-VZFVOw@mail.gmail.com>
References: <20171219101327.2165797-1-arnd@arndb.de> <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0@MWHPR21MB0846.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Jean Delvare <jdelvare@suse.de>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0@MWHPR21MB0846.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Dec 19, 2017 at 10:21 PM, Long Li <longli@microsoft.com> wrote:
>>       depends on CIFS && INFINIBAND
>> +     depends on CIFS=m || INFINIBAND=y
>
> How about we change them to
>
>         depends on CIFS=m && INFINIBAND || CIFS=y && INFINIBAND=y
>
> This makes it easy to read.

Yes, that seems fine. I would normally group them using () to avoid
any confusion with operator precedence, but your version is
also correct, so just pick the one you like best.

       Arnd
