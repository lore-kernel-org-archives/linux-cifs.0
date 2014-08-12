From: Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] SMB/CIFS nounix support for Connectathon test suite
Date: Tue, 12 Aug 2014 06:57:53 -0400
Message-ID: <53E9F331.6020302@RedHat.com>
References: <1407326472-13853-1-git-send-email-pshilovsky@samba.org> <CAKywueQjWzfUCw0r=Nnx2ehaOOv++76iRV2HZwFKZZYr=SD84g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQjWzfUCw0r=Nnx2ehaOOv++76iRV2HZwFKZZYr=SD84g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On 08/12/2014 03:20 AM, Pavel Shilovsky wrote:
> 2014-08-06 16:01 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> The goal of the series is to add support of testing various versions of SMB/CIFS protocol without Unix extensions. Also there are two patches that fixes problems in special and tlock tests.
>>
>> With the patchset applied nounix SMB/CIFS servers and clients can be tested with "server -C" command.
>>
>> Jeff Layton (2):
>>   tlock: munmap missed before close
>>   Add SMB/CIFS mounts support
>>
>> Pavel Shilovsky (3):
>>   Add capability to test SMB 2.0 and higher verions
>>   Add SMB/CIFS section in tests.init
>>   special: fix op_unlk and op_ren tests output
>>
>>  basic/runtests       |  8 +++++---
>>  lock/runtests        |  9 +++++++--
>>  lock/tlock.c         | 11 +++++++++--
>>  server               |  5 +++--
>>  special/op_ren.c     | 16 +++++++++++++---
>>  special/op_unlk.c    |  8 +++++---
>>  special/runtests.wrk | 11 ++++++++---
>>  tests.init           |  4 ++++
>>  8 files changed, 54 insertions(+), 18 deletions(-)
>>
>> --
>> 1.8.1.2
>>
> 
> Any comments on this series?
> 
Yes... I took a look... They look fine... 
Its on my TODO list... 

thanks!

steved.
