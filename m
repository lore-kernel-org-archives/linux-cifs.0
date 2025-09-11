Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB4313E16
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598934; cv=none; b=KIP9VduigUiUSwe32qYEzYEgbMVWBjCDwsBztd79hqYqF7R/ujbKrUcIq0eV0yLlOJBMfzWmGb14YZCCpXw2No1XhdwzwKIMfJ9nmJRKnNt8WrrF3ww3eXh1SCh/hLr/y/w7MbADwtrRnXGn7LyUjbM3c07C0wiwu8ecW2fTbfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598934; c=relaxed/simple;
	bh=GYlGfbymG4X8o4+5X/bMhKpLt0CehyCK2550Z4HXVns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcZlPb6UsNjr4IOZ9a4YXl1AMbgWUXo5sh+xvrIDlMReJdD6no7eGdnKNKhhAccLysZoXibhHykXO85/LvwT2XJjCHHovFeghoBIZ3YFbvisyslUGk156k1ZEm/RzHvz0TZMD8fXwiOaCaFjnOc8H6JHZFHXxEMYFd/xHWsBaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JIRpFU+x; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JIRpFU+x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=YoQ2J/J1tXvyWilWWx+77Sw4dLkaHQX81wxCjvUkH/c=; b=JIRpFU+xde2n/tercJVV3fe0Cy
	iqyg2L2LJtQUCaUdop7Fi84OC1susFZlocWygoq1pnPeVTzaSh6LCMpEK2YhsFQ3t7ud/oMRSTEce
	MU4ATWoyJpJ57uPV+FTO/pltjHSvJKYZxhPmPk4sTDfTt1MTKeUcPvISqHH+7caQzUyw3xBFzA9ep
	xHJlifMs3SHKxa+XgE3wWg6VupprDjjMWsOxwOQUGnUywSXfe9EBg1VeAUJoybW75PDR/smNnN4KX
	rywzFAJjWL+4yZtzHxSPZaS9xKWyecbkCtiWPwa6ey99w8LhrF+7wxAiest4ellWqNeUzzcgkrFrY
	ouMT/DZVOmIW+yw0WrLntm/v2lkX7lgn27xMtN3l4xZ3nuC2gxDEe3vwCIr5U9SxoOl5M+hTx/AW1
	XVNlVJ2nitM4KhDhnQV+WAl529gQ0/spc/ufgI7qXXHBEn9YUdwPgVd/1L0/qCG4eX/LLnEyZ110D
	nq9re37lig4Hoe54Tg0ZEayo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uwhlo-003ca1-0H;
	Thu, 11 Sep 2025 13:55:28 +0000
Message-ID: <b4373c49-6c3e-40fd-b942-b7a967833eaa@samba.org>
Date: Thu, 11 Sep 2025 15:55:27 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: skip cifs_lookup on mkdir
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Steve French <smfrench@gmail.com>
Cc: ematsumiya@suse.de, linux-cifs@vger.kernel.org
References: <20250909202749.2443617-1-henrique.carvalho@suse.com>
 <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
 <CAH2r5muyRvOn_OgKimn05V8o-XDt8SVdDzVU7peRmT_KGNzdkQ@mail.gmail.com>
 <bdfb29eb-35ab-473c-be08-1e0857c3c96b@suse.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <bdfb29eb-35ab-473c-be08-1e0857c3c96b@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Henrique,

I'm also seeing problems with generic/005, before failing
it hangs a long time here:

root@ub1704-166:~# ps axuf | grep D
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         917  0.0  0.1  53408  3328 ?        Ssl  15:33   0:00 /usr/sbin/gssproxy -D
root        1037  0.0  0.2  10888  7508 ?        Ss   15:33   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root       11704  0.0  0.0   2824  1636 pts/1    D+   15:49   0:00  |           |           \_ touch symlink_self
root       11720  0.0  0.0   9784  2564 pts/3    S+   15:50   0:00      \_ grep --color=auto D
root@ub1704-166:~# cat /proc/11704/stack
[<0>] wait_for_response+0x195/0x250 [cifs]
[<0>] compound_send_recv+0xb9d/0x2ac0 [cifs]
[<0>] cifs_send_recv+0x22/0x40 [cifs]
[<0>] SMB2_open+0x352/0x17b0 [cifs]
[<0>] smb3_query_mf_symlink+0x1c0/0x3a0 [cifs]
[<0>] check_mf_symlink+0x281/0x7a0 [cifs]
[<0>] cifs_get_fattr+0xc5f/0x21b0 [cifs]
[<0>] cifs_get_inode_info+0xad/0x460 [cifs]
[<0>] cifs_do_create.isra.0+0xe4c/0x2250 [cifs]
[<0>] cifs_atomic_open+0x4f5/0x1120 [cifs]
[<0>] path_openat+0x244e/0x47a0
[<0>] do_filp_open+0x1e3/0x440
[<0>] do_sys_openat2+0x100/0x190
[<0>] __x64_sys_openat+0x127/0x220
[<0>] x64_sys_call+0x1bce/0x2680
[<0>] do_syscall_64+0x7e/0x960
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

I'm using these mount options
-ousername=root,password=test,noperm,vers=3.1.1,mfsymlinks,actimeo=0

I hope this helps tracking it down.

metze

Am 10.09.25 um 23:09 schrieb Henrique Carvalho:
> Hi Steve,
> 
> On 9/10/25 5:28 PM, Steve French wrote:
>> Henrique, I can repro the failure in generic/005 with your patches,
>> but am fascinated that one of your patches may have worked around the
>> generic/637 problem at least in some cases, but am having difficulty
>> bisecting this.
> 
> I had not seen the failures in generic/005, but I also had not tested
> with smb 2.1.
> 
> I will run more tests and dig into both generic/637 and the other
> failing cases.
> 
> I will get back to you once I have something more concrete.
> 
>>
>> On Wed, Sep 10, 2025 at 12:50 PM Steve French <smfrench@gmail.com> wrote:
>>>
>>> Interesting that running with three of your patches, I no longer see
>>> the failure in generic/637 (dir lease related file contents bug) but I
>>> do see two unexpected failures in generic/005 and generic/586:
>>>
>>> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/116
>>>
>>> e.g.
>>>
>>> generic/005 5s ... - output mismatch (see
>>> /data/xfstests-dev/results//smb21/generic/005.out.bad)
>>>      --- tests/generic/005.out 2024-05-15 02:56:10.033955659 -0500
>>>      +++ /data/xfstests-dev/results//smb21/generic/005.out.bad
>>> 2025-09-10 08:33:45.271123450 -0500
>>>      @@ -1,8 +1,51 @@
>>>       QA output created by 005
>>>      +ln: failed to create symbolic link 'symlink_00': No such file or directory
>>>      +ln: failed to create symbolic link 'symlink_01': No such file or directory
>>>      +ln: failed to create symbolic link 'symlink_02': No such file or directory
>>>      +ln: failed to create symbolic link 'symlink_03': No such file or directory
>>>      +ln: failed to create symbolic link 'symlink_04': No such file or directory
>>>      +ln: failed to create symbolic link 'symlink_05': No such file or directory
>>>
>>> Do you also see these test failures?
>>>
>>> On Tue, Sep 9, 2025 at 3:30 PM Henrique Carvalho
>>> <henrique.carvalho@suse.com> wrote:
>>>>
>>>> For mkdir the final component is looked up with LOOKUP_CREATE |
>>>> LOOKUP_EXCL.
>>>>
>>>> We don't need an existence check in mkdir; return NULL and let mkdir
>>>> create or fail with -EEXIST (on STATUS_OBJECT_NAME_COLLISION).
>>>>
>>>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>>>> ---
>>>>   fs/smb/client/dir.c | 4 ++++
>>>>   1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
>>>> index 5223edf6d11a..d26a14ba6d9b 100644
>>>> --- a/fs/smb/client/dir.c
>>>> +++ b/fs/smb/client/dir.c
>>>> @@ -684,6 +684,10 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>>>>          void *page;
>>>>          int retry_count = 0;
>>>>
>>>> +       /* if in mkdir, let create path handle it */
>>>> +       if (flags == (LOOKUP_CREATE | LOOKUP_EXCL))
>>>> +               return NULL;
>>>> +
>>>>          xid = get_xid();
>>>>
>>>>          cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
>>>> --
>>>> 2.50.1
>>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>>
>>
> 

