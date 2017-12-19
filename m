From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Tue, 19 Dec 2017 11:56:38 +0100
Message-ID: <CAK8P3a3TQSt8skuyu7uHBbyG_jHS8wUaPPJ1XSh4u+aHxBzN8w@mail.gmail.com>
References: <20171219101327.2165797-1-arnd@arndb.de> <77af1425-2d5a-8482-fa39-c83d2056eaa4@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Jean Delvare <jdelvare@suse.de>
To: Stefan Metzmacher <metze@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <77af1425-2d5a-8482-fa39-c83d2056eaa4@samba.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Dec 19, 2017 at 11:33 AM, Stefan Metzmacher <metze@samba.org> wrote:
> Hi Arnd,
>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 500fd69fb58b..3bfc55c08bef 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -199,6 +199,7 @@ config CIFS_SMB311
>>  config CIFS_SMB_DIRECT
>>       bool "SMB Direct support (Experimental)"
>>       depends on CIFS && INFINIBAND
>> +     depends on CIFS=m || INFINIBAND=y
>>       help
>>         Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
>>         SMB Direct allows transferring SMB packets over RDMA. If unsure,
>
> Is this really correct? Should CIFS_SMB_DIRECT be allowed with:
>
> CIFS=n and INFINIBAND=y ???
> or
> CIFS=m and INFINIBAND=n ???
>
> I guess a more complex logic should be used here
> or am I missing something?

The two ones you listed are prohibited by the existing
'depends on CIFS && INFINIBAND' dependency.

We could rephrase the dependency as

depends on (CIFS=y && INFINIBAND=y) || \
            (CIFS=m && INFINIBAND=y) || \
            (CIFS=m && INFINIBAND=m)

which has the same effect as

      depends on CIFS && INFINIBAND
      depends on CIFS=m || INFINIBAND=y

but I don't think that adds any clarity.

      Arnd
