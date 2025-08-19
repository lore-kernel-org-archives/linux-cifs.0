Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2471927E1C5;
	Tue, 19 Aug 2025 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755615405; cv=none; b=RIxOOPQ8Szu4bDpn16g4JO8Up9HAJyqV41Sb4gZgtj2XTyFHEe3l0T71KZEt6w4nMnzTku/QJqAYQRGVThq6NjWVASznxouzILwWQpGnfKtD2CK4jGbLed2rH3AlDUCbXAtRky47PJTOjKy/t1P6InJ8tIeHfE2olGERSRI2Wj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755615405; c=relaxed/simple;
	bh=bUsDKewtvp1b2vKlIYgLqyZp8TdJkhLH1lo33Ru1UKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WkeydzImCkRXU9E1pEiOzGBad/p7NnEmn2P9yVs7sY4WkuZtqLrnDlN64McKJYCJvQ8NWbYcx6I/vh2SypJDKg6yZGi8K7W0ccUE1ZUzzhBUdBIFFqaRN5wNtHPdFw8AZbm2gMO9CvyMLgyhky3Cd9SIRmhvucJby3fEdKuLf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2e61108dso392749b3a.0;
        Tue, 19 Aug 2025 07:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755615402; x=1756220202;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKxtMwITbgg+OywFpBH8T4AA1fvAKojwdWxhEzg459M=;
        b=Rh7qm96PxA9gk46oFcRhc+lLw9563BmNdMY01wXVvoeSWBXzcJ/OmJDSqWdcbUmJ4D
         4HhpeTlZeXfP5QTLF9CdfWHTc1gxyW6FntDSnfi6BF/GCqo5uXZMfiLgo+KbFvZyZXEG
         +nGeZWGeAXJ2O8g9tVNhPCkVOB3P3xPbenbitCPKkf5laT3Tp87I1u5oP+w+/m27aaLG
         Be/HB4OMuJ74Mk2NIMol050FB/4y3u0j4IWMc2peI6HMbxhbaTipj1QehWsIXU4lul/e
         s1dwW2kJJg0fTsn1GJP7La0HTXgOjGqqpLiXnq2nDkS4d5EWBT643W+iU5SyPwQiV71n
         jM8w==
X-Forwarded-Encrypted: i=1; AJvYcCXeNTXU7rhCfMAgDJ1zno+oN6O0MNS4VyjC8atUrEOBQ+Qx7Qi/hXDQzGObZ8/jc4t/iuZaMzi7yQw8@vger.kernel.org, AJvYcCXeSN5OFzuDAy/onVwbLRzrcRRmTPo6pl1OjudXYIchCoAMOoB5rTUJsW+RteTd0gKW9xjSxf8X4LN3RkoR@vger.kernel.org
X-Gm-Message-State: AOJu0YwHqxBfe33SJY4UGOVKw4zrAbjVrwthavzJQj7I53Yg6R3PSwje
	92cIQCKIez18S6NmrpXvO3gVFbM+gj8cK0vfUtBbqHn/86Fo1/ABXWha
X-Gm-Gg: ASbGncvr+8SXqL12+umF4fCzjqre12WjDt8HerCu8suIE4nJbLYhFLA+nHCHs0MvBNY
	NAnwLLF6vxe4K3STxy5aIYKVA/hRf8wDSMUkm+qx+PSkfjZooTSq4qEn/vuV/tG+PymQxtM7Dmj
	MuRbEW3Pm6hUpxzRRRVllFFIUCs3+XVVp1ESxTYUzev+Hyu/8Gs21lGHn2X+mXiBjSvQ632a7Ky
	Ab7T9Z19fG4ltGrBzwcDJlfwL2SjK/efA3apdoNZZ2uZcsO9VljukNZzRAEggXfjAev7znJSEQJ
	CRNPPf1qnicWIlKFjhXBs7HxaQY7miVDrBoCy43/Y8dX+5pbiPx8rE6WKOMorMvKQ0073NLXZ9a
	JEw2wwwZvLPXJswQ0XQCUF/aKtkj3UXMhSMi4U3AQMJk=
X-Google-Smtp-Source: AGHT+IFiBXFUk8G1EL2FF8x3trLuns2m/hrb1OvL5B3+4opDQT4FS5T6ik8kXL0ZR6nR6/hhZMi5Kw==
X-Received: by 2002:a05:6a20:2451:b0:23f:f550:6e2b with SMTP id adf61e73a8af0-2430d4bf98cmr2009854637.6.1755615402247;
        Tue, 19 Aug 2025 07:56:42 -0700 (PDT)
Received: from [192.168.50.136] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d73aa36sm10823572a12.35.2025.08.19.07.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:56:41 -0700 (PDT)
Message-ID: <13b10448-9743-4f05-9662-370862c2040e@kzalloc.com>
Date: Tue, 19 Aug 2025 23:56:36 +0900
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksmbd: add kcov remote coverage support via ksmbd_conn
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>,
 Paulo Alcantara <pc@manguebit.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, syzkaller@googlegroups.com,
 linux-kernel@vger.kernel.org, notselwyn@pwning.tech
References: <20250806143955.122816-2-ysk@kzalloc.com>
 <CAKYAXd-7ojpN=jc+R2wwxyQsZCTBJT6tEYszb4VOgbPeWn1NKA@mail.gmail.com>
Content-Language: en-US
From: Yunseong Kim <ysk@kzalloc.com>
Organization: kzalloc
In-Reply-To: <CAKYAXd-7ojpN=jc+R2wwxyQsZCTBJT6tEYszb4VOgbPeWn1NKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Namjae,

Thank you for the review and the detailed questions.

On 8/19/25 5:00 PM, Namjae Jeon wrote:
> On Wed, Aug 6, 2025 at 11:41 PM Yunseong Kim <ysk@kzalloc.com> wrote:
>>
> Hi Yunseong,
>> KSMBD processes SMB requests on per-connection threads and then hands
>> off work items to a kworker pool for actual command processing by
>> handle_ksmbd_work(). Because each connection may enqueue multiple
>> struct ksmbd_work instances, attaching the kcov handle to the work
>> itself is not sufficient: we need a stable, per-connection handle.
>>
>> Introduce a kcov_handle field on struct ksmbd_conn (under CONFIG_KCOV)
>> and initialize it when the connection is set up. In both
>> ksmbd_conn_handler_loop() which only receives a struct ksmbd_conn*
>> and handle_ksmbd_work() which receives a struct ksmbd_work*, start
>> kcov_remote with the per-connection handle before processing and stop
>> it afterward. This ensures coverage collection remains active across
>> the entire asynchronous path of each SMB request.
> I'm a bit unclear on the overall impact. Do you have the goal to measure
> the code coverage of all ksmbd components ?

Yes, exactly. The ultimate goal is to effectively fuzz ksmbd using
syzkaller. To achieve this, it is essential to maximize the code coverage
of the core components involved in handling SMB requests.

The primary motivation for this patch is to address the limitations of KCOV
within ksmbd's asynchronous architecture. Ksmbd receives requests on
connection threads but offloads the actual command processing to a kworker
pool via handle_ksmbd_work(). Previously, the coverage from code executed
in the worker threads was not associated with the initial connection's KCOV
handle, resulting in lost coverage data.

By introducing a stable KCOV handle on struct ksmbd_conn, this patch
ensures that code coverage is accurately tracked across the entire
execution path of an SMB request, from reception to the completion of
asynchronous processing. This is the key impact of this change.

> Is there the next patch set or any plan for next work, or is this patch enough
> to check all functions of ksmbd with syzkaller?

This patch provides the necessary kernel-side infrastructure required to
collect accurate coverage data. It is a crucial prerequisite.

However, this patch alone is not sufficient to check all ksmbd functions.
To actually exercise and test ksmbd's functionalities, corresponding
user-space support in syzkaller (such as syscall descriptions) is required
o leverage this infrastructure. As mentioned in the commit message, that
work is currently in progress here:

Link: https://github.com/google/syzkaller/pull/5524

I am currently investigating cases where Samba, as you previously mentioned,
is mounted on the client and actually writing files exceeds the permissions.
In this process, I discovered a potentially serious vulnerability in netfs.
I have separately reported this issue privately to David Howells.

> Thanks.

In summary, both this kernel patch and the ongoing syzkaller PR need to be
merged to enable effective fuzzing and coverage analysis of ksmbd.

>> The kcov context tied to the connection itself, correctly supporting
>> multiple outstanding work items per connection.
>>
>> In patch v2, I added the missing initialization of kcov_handle. In v3,
>> I fixed an kcov_hanlde argument was previously unused on
>> ksmbd_conn_set_kcov_handle().
>>
>> The related work for syzkaller support is currently being developed
>> in the following GitHub PR:
>> Link: https://github.com/google/syzkaller/pull/5524
>>
>> Based on earlier work by Lau.
>> Link: https://pwning.tech/ksmbd-syzkaller/
>>
>> Cc: linux-cifs@vger.kernel.org
>> Cc: notselwyn@pwning.tech
>> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
>> ---
>>  fs/smb/server/connection.c |  7 ++++++-
>>  fs/smb/server/connection.h | 22 ++++++++++++++++++++++
>>  fs/smb/server/server.c     |  4 ++++
>>  3 files changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
>> index 3f04a2977ba8..21352f37384f 100644
>> --- a/fs/smb/server/connection.c
>> +++ b/fs/smb/server/connection.c
>> @@ -93,6 +93,9 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>>         down_write(&conn_list_lock);
>>         list_add(&conn->conns_list, &conn_list);
>>         up_write(&conn_list_lock);
>> +
>> +       ksmbd_conn_set_kcov_handle(conn, kcov_common_handle());
>> +
>>         return conn;
>>  }
>>
>> @@ -322,6 +325,8 @@ int ksmbd_conn_handler_loop(void *p)
>>         if (t->ops->prepare && t->ops->prepare(t))
>>                 goto out;
>>
>> +       kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
>> +
>>         max_req = server_conf.max_inflight_req;
>>         conn->last_active = jiffies;
>>         set_freezable();
>> @@ -412,7 +417,7 @@ int ksmbd_conn_handler_loop(void *p)
>>                         break;
>>                 }
>>         }
>> -
>> +       kcov_remote_stop();
>>  out:
>>         ksmbd_conn_set_releasing(conn);
>>         /* Wait till all reference dropped to the Server object*/
>> diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
>> index dd3e0e3f7bf0..a90bd1b3e1df 100644
>> --- a/fs/smb/server/connection.h
>> +++ b/fs/smb/server/connection.h
>> @@ -15,6 +15,7 @@
>>  #include <linux/kthread.h>
>>  #include <linux/nls.h>
>>  #include <linux/unicode.h>
>> +#include <linux/kcov.h>
>>
>>  #include "smb_common.h"
>>  #include "ksmbd_work.h"
>> @@ -109,6 +110,9 @@ struct ksmbd_conn {
>>         bool                            binding;
>>         atomic_t                        refcnt;
>>         bool                            is_aapl;
>> +#ifdef CONFIG_KCOV
>> +       u64                             kcov_handle;
>> +#endif
>>  };
>>
>>  struct ksmbd_conn_ops {
>> @@ -246,4 +250,22 @@ static inline void ksmbd_conn_set_releasing(struct ksmbd_conn *conn)
>>  }
>>
>>  void ksmbd_all_conn_set_status(u64 sess_id, u32 status);
>> +
>> +static inline void ksmbd_conn_set_kcov_handle(struct ksmbd_conn *conn,
>> +                                      const u64 kcov_handle)
>> +{
>> +#ifdef CONFIG_KCOV
>> +       conn->kcov_handle = kcov_handle;
>> +#endif
>> +}
>> +
>> +static inline u64 ksmbd_conn_get_kcov_handle(struct ksmbd_conn *conn)
>> +{
>> +#ifdef CONFIG_KCOV
>> +       return conn->kcov_handle;
>> +#else
>> +       return 0;
>> +#endif
>> +}
>> +
>>  #endif /* __CONNECTION_H__ */
>> diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
>> index 8c9c49c3a0a4..0757cd6ef4f7 100644
>> --- a/fs/smb/server/server.c
>> +++ b/fs/smb/server/server.c
>> @@ -264,6 +264,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
>>         struct ksmbd_work *work = container_of(wk, struct ksmbd_work, work);
>>         struct ksmbd_conn *conn = work->conn;
>>
>> +       kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
>> +
>>         atomic64_inc(&conn->stats.request_served);
>>
>>         __handle_ksmbd_work(work, conn);
>> @@ -271,6 +273,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
>>         ksmbd_conn_try_dequeue_request(work);
>>         ksmbd_free_work_struct(work);
>>         ksmbd_conn_r_count_dec(conn);
>> +
>> +       kcov_remote_stop();
>>  }
>>
>>  /**
>> --
>> 2.50.0
>>
Please let me know if you have any further questions.

Best regards,
Yunseong Kim.


