Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28D27E7EC
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 20:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770926711; cv=none; b=VFdBMpVKedTf1fCBXIUBHspuJWzsQ5ttVUMWFCYlhA/CKjzr6uKkzrRHhEmoKzL/aw3Tf9X8zDe8AG7K12XI04UvBNEiX7LL7k9Geag5d8vWWF7MthsUhrMcFqMTL6wKJs52BeYD2nq+z9ByUR2EvDCL1/l/8p4ozbs479VYky0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770926711; c=relaxed/simple;
	bh=OJPFDJFdCfE17d7ThD1BrxPn2sPYojgQGGlgyoLZNBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fUCdjKe0mlPe0mKochOd8aJTnF9SIDdQjLESuYC6RXkYVLyyP/s7qpaYM/ararrC7yHA9x8D0cJPl49JwnlICzzDkkoHbZxKSpfGX71J4s2ysJcTNSaKZ9vCRfoeHNCWwPkquQiKGrQIq1D+b7AUm1G4zPMI6Eb8HaCUruVzbFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hVlfkR8s; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hVlfkR8s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=NmBm15/rAYj+8bkANWYYgroNNHdwPYM9OWB/2l3XEQk=; b=hVlfkR8sHcKCRh7utDZFJCVIhd
	49hml9zpZD1iOUVhSqbTsFKJQpmXK4wiR1y1aCNzE0mTwC7VleOe5bJ0Oy19EyRHMT0B7mwUEFgE9
	UilsNyO+MVnoW56l5DY4da1IgJ4hC/MXm3Xo6vfNeRMkcbAjNB8zP+5M8cwC8NgTQJe7bSw/Tv0ot
	8lQWYCKoJ2qR6GUs4Amkw5JtJbRAirrjVrBFdp1F0xvQwhZRirCjCN6WFI4sX7qrB3UyeI9QbZZJt
	zqu2wmobys0ZMFgZjE35aTE6wYVZiJ5CWbC+c+8GKIoWYvkcd4cPE3byQpCIMERhnxIBU1yETYpRH
	8aeLm06Z40tkC0Wjmq6xqwqabvE38snipV5fCFJfqw2tQ06A/Ihh9lpSGkhJ6wxoukoNLpvCA9mC+
	VC/r/oOmrn+6VhKV3r3cReiGpZATvMwdM0optX45drB0sLnWXpJe3cZ7Ch1CKMm94sECytnegVRWr
	rx0dCYoVB771HROpmZYbxnSM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vqcvu-00000005zJ6-0NhJ;
	Thu, 12 Feb 2026 20:05:02 +0000
Message-ID: <3ecc1979-e736-4aa8-add0-670026808255@samba.org>
Date: Thu, 12 Feb 2026 21:05:01 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>
References: <cover.1770311507.git.metze@samba.org>
 <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org>
 <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
 <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.02.26 um 15:37 schrieb Namjae Jeon:
> On Tue, Feb 10, 2026 at 4:11 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Am 09.02.26 um 14:22 schrieb Stefan Metzmacher via samba-technical:
>>> Am 09.02.26 um 08:29 schrieb Namjae Jeon:
>>>>>
>>>>> I tested with with mlx5_ib, irdma (roce) and rxe.
>>>>> There's still a known problem with iwarp.
>>>> Let me know what the known problem is.
>>>
>>> It's the rw credit deadlock, as use rw credits
>>> for the wrong thing, which means we easily deadlock
>>> if the client uses an array smbdirect_buffer_descriptor_v1,
>>> where the could larger than the possible rw credits
>>> be calculated. While the max possible rw credits we calculate
>>> is the value that is needed in order to
>>> transfer the maximal rw size into a single
>>> smbdirect_buffer_descriptor_v1.
>>>
>>> This commit adds a WARN_ONCE detection for the
>>> problem:
>>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=e6260d7a518972ae1ca627e411cc16095c044d59
>>>
>>> See the diff and commit messages of the top ~15 commits
>>> in my for-6.18/ksmbd-smbdirect-regression-v4, which try to
>>> fix the problem.
>>>
>>> I try to fix it once I have the needed pcie adapters in
>>> order to out my Chelsio T520-BT cards into the free x4 slot
>>> of my testservers.
>>>
>>> As there are some strange page fault problems with the irdma
>>> driver, see
>>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=a6b515cda103c1ac1537c92a4e9dbd75a31d92ef
>>> And also
>>> https://git.samba.org/?p=metze/samba/wip.git;a=commitdiff;h=e784b53167dc2cf4316b66a7599dab5b9e6c7208
>>>
>>> For the client problem with irdma, see
>>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=fb5cc2a59b4719015979a1f1355f66f27002b4cf
>>> irdma_map_mr_sg may merge sg elements any may not return
>>> the same value as the given sg_nents on success.
>>>
>>>>>
>>>>> So far I can't see any regression compared the
>>>>> state before these 144 patches.
>>>>>
>>>>> Namjae, can you please test in your setup?
>>>>
>>>> Is there any reason to print the log below by default?
>>>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>>>> called from smbdirect_socket_shutdown in line=650 status=LISTENING
>>>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>>>> called from smbdirect_socket_shutdown in line=650 status=LISTENING
>>>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>>>> called from smbdirect_socket_shutdown in line=650 status=CONNECTED
>>>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>>>> called from smbdirect_socket_shutdown in line=650 status=CONNECTED
>>>
>>> I can move the above message to level INFO.
>>>
>>>> ksmbd: smb_direct: status=ERROR first_error=-ESHUTDOWN => -ENOTCONN
>>>
>>> This is basically the same messages as the one we
>>> had in smb_direct_read() before:
>>>
>>>           if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
>>>                   pr_err("disconnected\n");
>>>                   return -ENOTCONN;
>>>           }
>>>
>>> If I remember correctly it appeared just as:
>>>
>>> 'ksmbd: disconnected'
>>>
>>> I can just move the new message to level INFO too, ok?
>>
>> My master-fs-smb branch has 3 commits which should disable the
>> messages by default, let me know if your happy with the logic
>> and I'll squash them to the correct commit.
>>
>> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=8b2f53aec19ebc180c11504600b5e5372d2220cb
> Looks good to me.
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> for this series.

I squashed these and rebased on Linus' tree, as all other stuff is now
already merged.

It is available in my for-7.0/smbdirect-ko-20260212-v6 branch
at commit d4fd5f7a6a7e0f4918d988b3125a59d05fbc9ac2:
git fetch https://git.samba.org/metze/linux/wip.git for-7.0/smbdirect-ko-20260212-v6
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.0/smbdirect-ko-20260212-v6

The logical diff compared to for-7.0/smbdirect-ko-20260205-v5 is only this:

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 5a65424ad010..813ddd87c6ae 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1304,7 +1304,7 @@ int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
                 return -EINVAL; /* It's a bug in upper layer to get there */

         if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-               smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+               smbdirect_log_write(sc, SMBDIRECT_LOG_INFO,
                         "status=%s first_error=%1pe => %s\n",
                         smbdirect_socket_status_string(sc->status),
                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
@@ -1801,7 +1801,7 @@ int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,

  again:
         if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-               smbdirect_log_read(sc, SMBDIRECT_LOG_ERR,
+               smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
                         "status=%s first_error=%1pe => %s\n",
                         smbdirect_socket_status_string(sc->status),
                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 657710d0387a..33610e2af589 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -647,7 +647,7 @@ __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_bind);

  void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
  {
-       smbdirect_socket_schedule_cleanup(sc, -ESHUTDOWN);
+       smbdirect_socket_schedule_cleanup_lvl(sc, SMBDIRECT_LOG_INFO, -ESHUTDOWN);
  }
  __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_shutdown);

metze
