Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2F7C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 21:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F6E610C7
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 21:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhIRVpR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 17:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234140AbhIRVpQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 18 Sep 2021 17:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BAD261050
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 21:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632001432;
        bh=Wrf4mzIFZlsxh/J69mudywq4gRdCPFY3UTqhinPrr0s=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=OkUt0RwImjBP+Uc4tmQuWO+edR6thN3A1TQOmtmgVAEGDcjg54TPgYFwvZuKukBkV
         13kc8jERLiBRAKQmUBC1lOHFvV+P9WiGkE/veSNP51XmFnsrfvQZN+nGQjAhp6N2Qw
         XRTQVuDkJc+3/xyEcXNNSlmtWWX3WrzTh5tWzoNqNkiJ11ZFQJYShGJ3Hmu9sbflNs
         hmv9v3GZT9CE2dsr7gjgnsxDAhRTsNEYj14R/e3ijGlSqEp+aHUU6GcTBYBZWUYFoU
         +m6ASkWiOwz5N6ANlENtgjpgTt6HQK+C+ZTCRLj/YnTSTRucn1FqM6Fch9bu78Nd5j
         oLDTWm964+hdw==
Received: by mail-ot1-f48.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so1514057ota.6
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 14:43:52 -0700 (PDT)
X-Gm-Message-State: AOAM533wAKBSvXpeJ2n/cNTa5shHur48EboHfwlCqawWIVePPlkJtkFU
        PF8SYi1NF65LccPReYOqIPzbpPBvwjZXvQBYhlk=
X-Google-Smtp-Source: ABdhPJysKns+bv3JlrpAGjT6uzIWgeL2v9zQM3XmuP6WR+CBRQQpZGFlSVYT4PW4t8qy0LYgZBjTbqDxK3WtrAMcM7o=
X-Received: by 2002:a9d:5e05:: with SMTP id d5mr15021152oti.61.1632001431810;
 Sat, 18 Sep 2021 14:43:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 18 Sep 2021 14:43:51
 -0700 (PDT)
In-Reply-To: <202109190257.fZUGN7K6-lkp@intel.com>
References: <20210918094513.89480-2-linkinjeon@kernel.org> <202109190257.fZUGN7K6-lkp@intel.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 19 Sep 2021 06:43:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jE3MwfwqbSxJ0E5DjPxU9mSH11onkqFcumbdMO21w8Q@mail.gmail.com>
Message-ID: <CAKYAXd_jE3MwfwqbSxJ0E5DjPxU9mSH11onkqFcumbdMO21w8Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] ksmbd: add validation in smb2_ioctl
To:     kernel test robot <lkp@intel.com>
Cc:     linux-cifs@vger.kernel.org, llvm@lists.linux.dev,
        kbuild-all@lists.01.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-19 3:51 GMT+09:00, kernel test robot <lkp@intel.com>:
> Hi Namjae,
Hi,

I will fix it, Thanks for your report!
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.15-rc1 next-20210917]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:
> https://github.com/0day-ci/linux/commits/Namjae-Jeon/ksmbd-add-request-buffer-validation-in-smb2_set_info/20210918-174717
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 4357f03d6611753936e4d52fc251b54a6afb1b54
> config: hexagon-randconfig-r022-20210918 (attached as .config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project
> c8b3d7d6d6de37af68b2f379d0e37304f78e115f)
> reproduce (this is a W=1 build):
>         wget
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O
> ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         #
> https://github.com/0day-ci/linux/commit/57e7ede2bf2d38cb0f368f2fc54d646168b3d119
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review
> Namjae-Jeon/ksmbd-add-request-buffer-validation-in-smb2_set_info/20210918-174717
>         git checkout 57e7ede2bf2d38cb0f368f2fc54d646168b3d119
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1
> ARCH=hexagon
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> fs/ksmbd/smb2pdu.c:7037:6: warning: variable 'ret' is used uninitialized
>>> whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (chunk_count == 0)
>                ^~~~~~~~~~~~~~~~
>    fs/ksmbd/smb2pdu.c:7120:9: note: uninitialized use occurs here
>            return ret;
>                   ^~~
>    fs/ksmbd/smb2pdu.c:7037:2: note: remove the 'if' if its condition is
> always false
>            if (chunk_count == 0)
>            ^~~~~~~~~~~~~~~~~~~~~
>    fs/ksmbd/smb2pdu.c:7020:9: note: initialize the variable 'ret' to silence
> this warning
>            int ret, cnt_code;
>                   ^
>                    = 0
>    1 warning generated.
>
>
> vim +7037 fs/ksmbd/smb2pdu.c
>
>   7009	
>   7010	static int fsctl_copychunk(struct ksmbd_work *work, struct
> smb2_ioctl_req *req,
>   7011				   struct smb2_ioctl_rsp *rsp)
>   7012	{
>   7013		struct copychunk_ioctl_req *ci_req;
>   7014		struct copychunk_ioctl_rsp *ci_rsp;
>   7015		struct ksmbd_file *src_fp = NULL, *dst_fp = NULL;
>   7016		struct srv_copychunk *chunks;
>   7017		unsigned int i, chunk_count, chunk_count_written = 0;
>   7018		unsigned int chunk_size_written = 0;
>   7019		loff_t total_size_written = 0;
>   7020		int ret, cnt_code;
>   7021	
>   7022		cnt_code = le32_to_cpu(req->CntCode);
>   7023		ci_req = (struct copychunk_ioctl_req *)&req->Buffer[0];
>   7024		ci_rsp = (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>   7025	
>   7026		rsp->VolatileFileId = req->VolatileFileId;
>   7027		rsp->PersistentFileId = req->PersistentFileId;
>   7028		ci_rsp->ChunksWritten =
>   7029			cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>   7030		ci_rsp->ChunkBytesWritten =
>   7031			cpu_to_le32(ksmbd_server_side_copy_max_chunk_size());
>   7032		ci_rsp->TotalBytesWritten =
>   7033			cpu_to_le32(ksmbd_server_side_copy_max_total_size());
>   7034	
>   7035		chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
>   7036		chunk_count = le32_to_cpu(ci_req->ChunkCount);
>> 7037		if (chunk_count == 0)
>   7038			goto out;
>   7039		total_size_written = 0;
>   7040	
>   7041		/* verify the SRV_COPYCHUNK_COPY packet */
>   7042		if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
>   7043		    le32_to_cpu(req->InputCount) <
>   7044		     offsetof(struct copychunk_ioctl_req, Chunks) +
>   7045		     chunk_count * sizeof(struct srv_copychunk)) {
>   7046			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>   7047			return -EINVAL;
>   7048		}
>   7049	
>   7050		for (i = 0; i < chunk_count; i++) {
>   7051			if (le32_to_cpu(chunks[i].Length) == 0 ||
>   7052			    le32_to_cpu(chunks[i].Length) >
> ksmbd_server_side_copy_max_chunk_size())
>   7053				break;
>   7054			total_size_written += le32_to_cpu(chunks[i].Length);
>   7055		}
>   7056	
>   7057		if (i < chunk_count ||
>   7058		    total_size_written > ksmbd_server_side_copy_max_total_size()) {
>   7059			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>   7060			return -EINVAL;
>   7061		}
>   7062	
>   7063		src_fp = ksmbd_lookup_foreign_fd(work,
>   7064						 le64_to_cpu(ci_req->ResumeKey[0]));
>   7065		dst_fp = ksmbd_lookup_fd_slow(work,
>   7066					      le64_to_cpu(req->VolatileFileId),
>   7067					      le64_to_cpu(req->PersistentFileId));
>   7068		ret = -EINVAL;
>   7069		if (!src_fp ||
>   7070		    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
>   7071			rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
>   7072			goto out;
>   7073		}
>   7074	
>   7075		if (!dst_fp) {
>   7076			rsp->hdr.Status = STATUS_FILE_CLOSED;
>   7077			goto out;
>   7078		}
>   7079	
>   7080		/*
>   7081		 * FILE_READ_DATA should only be included in
>   7082		 * the FSCTL_COPYCHUNK case
>   7083		 */
>   7084		if (cnt_code == FSCTL_COPYCHUNK &&
>   7085		    !(dst_fp->daccess & (FILE_READ_DATA_LE | FILE_GENERIC_READ_LE)))
> {
>   7086			rsp->hdr.Status = STATUS_ACCESS_DENIED;
>   7087			goto out;
>   7088		}
>   7089	
>   7090		ret = ksmbd_vfs_copy_file_ranges(work, src_fp, dst_fp,
>   7091						 chunks, chunk_count,
>   7092						 &chunk_count_written,
>   7093						 &chunk_size_written,
>   7094						 &total_size_written);
>   7095		if (ret < 0) {
>   7096			if (ret == -EACCES)
>   7097				rsp->hdr.Status = STATUS_ACCESS_DENIED;
>   7098			if (ret == -EAGAIN)
>   7099				rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
>   7100			else if (ret == -EBADF)
>   7101				rsp->hdr.Status = STATUS_INVALID_HANDLE;
>   7102			else if (ret == -EFBIG || ret == -ENOSPC)
>   7103				rsp->hdr.Status = STATUS_DISK_FULL;
>   7104			else if (ret == -EINVAL)
>   7105				rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>   7106			else if (ret == -EISDIR)
>   7107				rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
>   7108			else if (ret == -E2BIG)
>   7109				rsp->hdr.Status = STATUS_INVALID_VIEW_SIZE;
>   7110			else
>   7111				rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
>   7112		}
>   7113	
>   7114		ci_rsp->ChunksWritten = cpu_to_le32(chunk_count_written);
>   7115		ci_rsp->ChunkBytesWritten = cpu_to_le32(chunk_size_written);
>   7116		ci_rsp->TotalBytesWritten = cpu_to_le32(total_size_written);
>   7117	out:
>   7118		ksmbd_fd_put(work, src_fp);
>   7119		ksmbd_fd_put(work, dst_fp);
>   7120		return ret;
>   7121	}
>   7122	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
