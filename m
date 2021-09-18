Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE69BC433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 18:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C471160EC0
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 18:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhIRSxL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 14:53:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:52724 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhIRSxK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 18 Sep 2021 14:53:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="219774621"
X-IronPort-AV: E=Sophos;i="5.85,304,1624345200"; 
   d="gz'50?scan'50,208,50";a="219774621"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 11:51:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,304,1624345200"; 
   d="gz'50?scan'50,208,50";a="555361126"
Received: from lkp-server01.sh.intel.com (HELO 285e7b116627) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 18 Sep 2021 11:51:44 -0700
Received: from kbuild by 285e7b116627 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mRfR9-00054E-Fb; Sat, 18 Sep 2021 18:51:43 +0000
Date:   Sun, 19 Sep 2021 02:51:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph =?iso-8859-1?Q?B=F6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 2/4] ksmbd: add validation in smb2_ioctl
Message-ID: <202109190257.fZUGN7K6-lkp@intel.com>
References: <20210918094513.89480-2-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20210918094513.89480-2-linkinjeon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Namjae,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.15-rc1 next-20210917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Namjae-Jeon/ksmbd-add-request-buffer-validation-in-smb2_set_info/20210918-174717
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 4357f03d6611753936e4d52fc251b54a6afb1b54
config: hexagon-randconfig-r022-20210918 (attached as .config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project c8b3d7d6d6de37af68b2f379d0e37304f78e115f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/57e7ede2bf2d38cb0f368f2fc54d646168b3d119
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Namjae-Jeon/ksmbd-add-request-buffer-validation-in-smb2_set_info/20210918-174717
        git checkout 57e7ede2bf2d38cb0f368f2fc54d646168b3d119
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=hexagon 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/ksmbd/smb2pdu.c:7037:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (chunk_count == 0)
               ^~~~~~~~~~~~~~~~
   fs/ksmbd/smb2pdu.c:7120:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   fs/ksmbd/smb2pdu.c:7037:2: note: remove the 'if' if its condition is always false
           if (chunk_count == 0)
           ^~~~~~~~~~~~~~~~~~~~~
   fs/ksmbd/smb2pdu.c:7020:9: note: initialize the variable 'ret' to silence this warning
           int ret, cnt_code;
                  ^
                   = 0
   1 warning generated.


vim +7037 fs/ksmbd/smb2pdu.c

  7009	
  7010	static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_req *req,
  7011				   struct smb2_ioctl_rsp *rsp)
  7012	{
  7013		struct copychunk_ioctl_req *ci_req;
  7014		struct copychunk_ioctl_rsp *ci_rsp;
  7015		struct ksmbd_file *src_fp = NULL, *dst_fp = NULL;
  7016		struct srv_copychunk *chunks;
  7017		unsigned int i, chunk_count, chunk_count_written = 0;
  7018		unsigned int chunk_size_written = 0;
  7019		loff_t total_size_written = 0;
  7020		int ret, cnt_code;
  7021	
  7022		cnt_code = le32_to_cpu(req->CntCode);
  7023		ci_req = (struct copychunk_ioctl_req *)&req->Buffer[0];
  7024		ci_rsp = (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
  7025	
  7026		rsp->VolatileFileId = req->VolatileFileId;
  7027		rsp->PersistentFileId = req->PersistentFileId;
  7028		ci_rsp->ChunksWritten =
  7029			cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
  7030		ci_rsp->ChunkBytesWritten =
  7031			cpu_to_le32(ksmbd_server_side_copy_max_chunk_size());
  7032		ci_rsp->TotalBytesWritten =
  7033			cpu_to_le32(ksmbd_server_side_copy_max_total_size());
  7034	
  7035		chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
  7036		chunk_count = le32_to_cpu(ci_req->ChunkCount);
> 7037		if (chunk_count == 0)
  7038			goto out;
  7039		total_size_written = 0;
  7040	
  7041		/* verify the SRV_COPYCHUNK_COPY packet */
  7042		if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
  7043		    le32_to_cpu(req->InputCount) <
  7044		     offsetof(struct copychunk_ioctl_req, Chunks) +
  7045		     chunk_count * sizeof(struct srv_copychunk)) {
  7046			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
  7047			return -EINVAL;
  7048		}
  7049	
  7050		for (i = 0; i < chunk_count; i++) {
  7051			if (le32_to_cpu(chunks[i].Length) == 0 ||
  7052			    le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
  7053				break;
  7054			total_size_written += le32_to_cpu(chunks[i].Length);
  7055		}
  7056	
  7057		if (i < chunk_count ||
  7058		    total_size_written > ksmbd_server_side_copy_max_total_size()) {
  7059			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
  7060			return -EINVAL;
  7061		}
  7062	
  7063		src_fp = ksmbd_lookup_foreign_fd(work,
  7064						 le64_to_cpu(ci_req->ResumeKey[0]));
  7065		dst_fp = ksmbd_lookup_fd_slow(work,
  7066					      le64_to_cpu(req->VolatileFileId),
  7067					      le64_to_cpu(req->PersistentFileId));
  7068		ret = -EINVAL;
  7069		if (!src_fp ||
  7070		    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
  7071			rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
  7072			goto out;
  7073		}
  7074	
  7075		if (!dst_fp) {
  7076			rsp->hdr.Status = STATUS_FILE_CLOSED;
  7077			goto out;
  7078		}
  7079	
  7080		/*
  7081		 * FILE_READ_DATA should only be included in
  7082		 * the FSCTL_COPYCHUNK case
  7083		 */
  7084		if (cnt_code == FSCTL_COPYCHUNK &&
  7085		    !(dst_fp->daccess & (FILE_READ_DATA_LE | FILE_GENERIC_READ_LE))) {
  7086			rsp->hdr.Status = STATUS_ACCESS_DENIED;
  7087			goto out;
  7088		}
  7089	
  7090		ret = ksmbd_vfs_copy_file_ranges(work, src_fp, dst_fp,
  7091						 chunks, chunk_count,
  7092						 &chunk_count_written,
  7093						 &chunk_size_written,
  7094						 &total_size_written);
  7095		if (ret < 0) {
  7096			if (ret == -EACCES)
  7097				rsp->hdr.Status = STATUS_ACCESS_DENIED;
  7098			if (ret == -EAGAIN)
  7099				rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
  7100			else if (ret == -EBADF)
  7101				rsp->hdr.Status = STATUS_INVALID_HANDLE;
  7102			else if (ret == -EFBIG || ret == -ENOSPC)
  7103				rsp->hdr.Status = STATUS_DISK_FULL;
  7104			else if (ret == -EINVAL)
  7105				rsp->hdr.Status = STATUS_INVALID_PARAMETER;
  7106			else if (ret == -EISDIR)
  7107				rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
  7108			else if (ret == -E2BIG)
  7109				rsp->hdr.Status = STATUS_INVALID_VIEW_SIZE;
  7110			else
  7111				rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
  7112		}
  7113	
  7114		ci_rsp->ChunksWritten = cpu_to_le32(chunk_count_written);
  7115		ci_rsp->ChunkBytesWritten = cpu_to_le32(chunk_size_written);
  7116		ci_rsp->TotalBytesWritten = cpu_to_le32(total_size_written);
  7117	out:
  7118		ksmbd_fd_put(work, src_fp);
  7119		ksmbd_fd_put(work, dst_fp);
  7120		return ret;
  7121	}
  7122	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--T4sUOijqQbZv57TR
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICOApRmEAAy5jb25maWcAjDxbd+M2zu/9FTrTl+5DO7nNpfudPFASZXEtiQpJ2XFedDyO
Z+qvSZxjO7Ptv1+Q1AWUKE+35+xEAAiCIAgCIOmff/o5IG+n/fP6tNusn57+Dr5tX7aH9Wn7
GHzdPW3/L4h5UHAV0Jip34A42728/fX+j+1f62/7l+DDb5cffrv49bC5DObbw8v2KYj2L193
396Aw27/8tPPP0W8SNisjqJ6QYVkvKgVvVe37zZP65dvwfft4Qh0weXNbxe/XQS/fNud/v3+
Pfz/8+5w2B/ePz19f65fD/v/325Owebzl+vHT48f4b/t9af114+fv1x9vf70++MFfF5f3Hz9
9Hl7efnh67/etb3O+m5vL5AoTNZRRorZ7d8dUH92tJc3F/C/FkekbpBli7ynB5ifOIvHPQLM
MIj79hmicxmAeClwJzKvZ1xxJKKLqHmlykr1eMV5JmtZlSUXqhY0E962rMhYQUeogtel4AnL
aJ0UNVEKtWbirl5yMQcIzOjPwcyYyFNw3J7eXvs5DgWf06KGKZZ5iVoXTNW0WNREwLhZztTt
9VXXO89L3aeiUg/l56CBL6kQXAS7Y/CyP+mOOsXxiGSt5t51Mx1WDDQqSaYQMKYJqTJlJPCA
Uy5VQXJ6++6Xl/3LFsym614uSYk77xEruWBl5BGs5JLd1/ldRSukXQzVjSOV9cglUVFaty26
PiLBpaxzmnOx0jNBotTTXyVpxkJkkRWs0HaGYMaC49uX49/H0/a5n6EZLahgkZlQmO0QCYpR
MuVLd/ZjnhNWuDDJch9RnTIqiIjSFR4TZh/TsJol0tXv9uUx2H8dCD4ULoLZn9MFLZQcS46Q
2hRJHBGJlwfLaT2vtDE2xmY0pXbP4IN8ylIsmoMxU9AGYgPrJH3QZpvzAg8QgCWIwWPmMw7b
isUZHXDqP1M2S2HVSiOokIZ3o5SRjJ3Vl0k7DvjTNwgAG7MjGbI7DayKUrBFtxZ4kvR4MC2R
85jWMZBQgUVxu+msXFCalwqGZDyLESgqq/dqffwzOIH0wRqaH0/r0zFYbzb7t5fT7uXbQNXQ
oCZRxKtCMeyaQxlrY40oLArAq2lMvbjGU6KInEtFlPStVsnQIpWsU0TMJAkzGuNB/4OhdP4M
BsEkz4hixj6MKkRUBdJnYMWqBhyWGT5reg+WpDxCS0uMmw9AesSGR7MohiglSES7PpvhueK5
HjVkxRXiwub2jzHETAQGp5TE1o47z62ZgjmmLFG3l59642GFmoPvTuiQ5npAw4qY3rdalZs/
to9vT9tD8HW7Pr0dtkcDbgblwXZzNBO8KiVWOzjbaObReJjNG3K0YZrvWkYpRRt6QpiovZgo
AX9EinjJYpU6c61wA+920/RVsliew4s4Jx7pG2wCq/OBitEIYrpgER2BwYSbZTbsRi/+yV5y
JtH8Sx7Nu36IIsjtwY4rSzBDZBoVuOwCfcMOa787CbRLApBXCaCdAartiiqHLag5mpccTEk7
WsWFs+2aWYBtVHEjtm/9rSTMZUzB3UVE4TkeYurFlTPTNCOrCfOCWTABikDszDfJgaXklYA5
6oMXEdezB4bMEQAhANz+4jp78JoEYO4fnMbZAx81vfG3fJAKCRlyruqhO4Bokpewg7EHiCO5
0Hsi/JOTInJDnAGZhD98wV5cc1GmpIBQSRSOum0g1TGc9Jk5OHWmrWc4WaNdMYF+nA3axm7d
duy4IqSGCg2fZgmoRCAmIZEwxMrpqFLGi+FPMGLEpeSYXrJZQbIEqd7IhAEm7MEAmYJLQ8Eh
Q4kE43UlnC2WxAsmaasSNFhgEhIhGFbfXJOscjmG2MFqY1cQNwyXr9lfk9gzR/PI5Av9ZOYh
jWPqI03Jghqjqrsw0Hj9Jvsst4ev+8Pz+mWzDej37Qts0gT2g0hv0xBC2cCkmceeiTcS/Ycc
W8EWuWVWmwDGsRiZVaENetE6gbyHKIhT544Lykjo8zvAALMjIUyMmNE2aBngtL/PmAQnBwbN
8ylsSkQMUULsCJBWSQLpWEmAO8wqJFvKm4aBqSiaG9eu81iWsKgNeXoNm3wSDM2rXzeJNDNj
agveQkIAcxCktujQB1ApvSczjvxCA6jLdCV1SCsp0k0CHhVGpt0/NmedNYDjbhNntKaIyFaj
5Z7nKN7qUg9Z5WNouqQQ0+PZgVRubkOwUW9tI2slRh35evPH7mULGnrabtxySjtQMCM8xBas
06+uvNDn2nlsUv93ONHNfRtdIXQUIG8v0WRqi9Buur6Z+2y0x19+nIeOGXSYj4OmHpKrDx8n
aCB/ury4mEJdfZhEXbutHHYXSHcPt5eoDGOjgVTo1AQHy+NJcUoi6wOgT4CBiPPXx+0rtAKf
EexfNemxn0CwzDpBPsJaBWS/SUZmcmwexu+ZaTWUKefzse3AZJocs1apgOgb+Xfd8PoqZCbR
qxHfTPE2a2sNnMdVBmkouGyznWl3jna/mdLpUZ2Bs4ON4gpt6daj2V70BuVRupHDVJpMvugu
Quw/5UD2JQHMKBqwmo/44tcv6+P2MfjTeo7Xw/7r7skmmH0BAsjqORUFzfzu6Byboc/6wSx3
IZOC8AM2dxzqmi1S5jryuED5h1W6N0TkEY42IGIUd9Y1Gy27qDYfWOq810XpODOUs750McY5
9aQ+NlV0JphanUHV6vJijH7gBY6RWzAYJ1cqswFIp4ExFoxiOREzL8PB4ABQ53dDfo02mE7H
aRFNReAdWcSl8uqTcdgG+FhccNZ14p81SGjBf/CSZC5HW36tQRyxKoc7ppcAUsssC2HnwP0Y
0y7Xh9PObI/q79etG90Q8FymNcR2Ovr2BVMkZzPSkyIfIGMufQiaMAfcrYyhKHjI+V29YNCG
u5oAsM5bMVB7gZRnMeR6TpZla5q8T+qRJwU2jFtvHYPTc4vbCDlfhU0pqwuDLSJM7vylSKe/
TmeyuMSJmpksWbKirgojP/jwEV574wZ/Dudtu4QFRqcaY6Tbuk/6jfLoX9vN22n95WlrjnUC
E9OekBpDViS50h7fyWaiQZKsv+u4ysuuYKb3iKbW41sIlq2MBMP+vgG7NQPNW7PGdjUltw2Q
ts/7w9+wJb+sv22fvfssbKfKyYRkmcH+VCqjMRPk3DgxeeQavIlMBNWbsZMxwcoRo4B3LnOP
ClpF5TnRVRK9ImNxe3Px+8e+TgFmCPmIqR7Oc0ffGYXVS8BQ/fUfb5L/UHLuZMcPYeVb/w/X
CceHUg9mXzJlvL5pA9PBqy+/NgoyQYeOXJz1FbeJhA5Z5qM8oM/D9LBHhdp+5wYHrCv2I/cX
r0/rgGw22+MxyPcvu9P+4FSVY+JsdObTPQFwMAszL2gACIya+WbYEMbhDEd0COh22tn2lPxd
qDlp3qjAhQprVJ90zQSV0gXSAUzOw5rew46o04Mugy62p//uD3+CBGgVof0kmlPlnR8Y270X
oTKfR7hPBFqO+kvHpBnH8aqBkmzGByC3jmNAEnLrkmcsWg0QdoU6zss2AEOD9JdFU8LVJB2w
orIcQFipnYWr5jldjQA+KWQeedV1H5embEq9BxbMznW/ukpb2tKHXF52QNBu/TUEMZDz+riW
FqfPv6VkuARZ1mVRDr/rOI3GQF0JHEMFEQMNsZKNIDO9n9C8uh8ialUVEKzjMXctvAUJnQ3z
OaNy3GSh2ER5uIpRRwie8GoE6IXCpWqNxBZjAI7FtBBk5/0sNTgIpSNfJs7sAFxrM0Bjh0PR
DcYLjBmZDemi0gfWKmnArpiCLA3Cb25tJzCbUgnuC7Z1h/DnrDNMlP+2qNA5tGqhUeWHL6Gv
JeeOSjtk6ldpj5cqKv0tV2Hm21g7ggWdEeltWizOtdP1VZ0/e5tm/isHqNOCn2O+otgOOzDL
IFTkTHpQcaTwcu7VHc98UxO622MT14TeE+8W287cqJlRoXfALUU7uWeJzBDOUsBgzuJhWGfx
wq/2Ft2q5/bd5u3LbvPOnbg8/iDZxIopFx+9CFhJYCRunaINO0tnwsyiM7DRirVQf9iCe9L3
eiBVhUBSzCd8ZKnKZn9IVgPfalqX6cqUImBnzctBmNeTJixTbgLWAb05qo0+9oetjkwg9j9t
D6PLZR5WTQR0TgajYFbMHQffoBLIibNVHQoWz+gZguHe5nLW59gIrc+EisJEwQ5Un3bLlbTE
/VgQuTlV91YYHCpjLtLfY53gvdnBMBFNYDz3Zxw8jDOE/Nk5XXUIJCuHY1KtdvyjKYjbGXyP
RNewodAaJtmYDnJJJmg0ZpoTeVdRARmrgzJ1TekBabFjusAYGEqVz2jhwty+upMgFziabGXv
xPnXZ2LF9WqsGeJALjIQwhNFAZSH/xE0mezzruKKTGIF/Q/odRJtC8ETIqdEpq6ACS46akCT
IDg8bVw8wVPBIrlfOTMXQ87om7YpeLKMx/BuVd93tmF8zr2pRxyDzf75y+5l+xg873WRCFUd
cNNae9Zh09P68G17mmqhiJhRNXAimMCdZU9TgOXEXYE+KghH/XuTj7pdUGdda0/uXWYeOtim
cjnS7fP6tPnjjEr1xUmdmKtVOcXfEmHP6x+epbM55I/GZml1CklxJn92m0JpkXMeab+B5f3t
1YePA2jI9ATWrBzRd5icRFNI9+yowemlV7tu2cVMhAAu0TnWpkp2pgONL7zLeCjIeGQGNYkA
rg3zSfyUWIAqJiobnh5+IDtQsYTgS1UN1py4D6d/IQefw1sCFgjeR0+svL28airh5UIGp8P6
5fi6P5z0QdVpv9k/BU/79WPwZf20ftnoMs7x7VXjcZxkGYK/VLyeSDgRBWSCQ1ksgqRNhutl
DKgfMHbyZQSXkdnw+0Ee2wL8eBBiop4BqKUQQ/5ZNIQsx6CEj4fEF747bw3TMIvGLTTUn1E0
c5yeQcpzyNx3D7xpR+PhaIq7sWwQsMtRkG00DR1jZQ+E6m3wM2qTn2mT2zb2xqZjuOvX16fd
xl7r+GP79DpuWyTRcKHUJW2ivIbRv8+kBSgOoIkgJtW6GYSjNqIwGH88aqOKtukoKBzCbWwx
hkJ4M8nDTSISLweTJFhCLL6GTstuI7QBL9AjoFg5DHQtfJyeWXi3+Q9jPofKCUichr4wwBLk
pJhlI6ggS7yznpvosUJHaVuiGlidU3MJ1Z9lWRrf8ZVtDMQ07PTWH9daLKB0wlSpMxw0jeqV
7EM6OkSYzxdX9bUXo08YZn6MazAIw3y+GeHtAx0fzyaOHSPKuXLDMISTOIND8EVGiinJBS2z
1YT4ceFNLQZi1v4RjFNCLOmU/p0wHMFN9Iww5XB2waDjaFSu0aC2WmOPsQAQRBGLj9P1jYZV
rcmubJQwtU90dNfeU+3J3nDAYrdhdDNalfokS6eNUeF9mWAo2oKbKcPXKURruv415uShkym5
9D+4mmqhby1NSfIjCc71jOfKdu6UyEUsnY/aKchpwCCGg4jYCRL0N3gj4KrjK3/FV5OY6x/e
eq/GukIRlTsfdZThzKGF6KtXbHDXVuNgLfqPlzUyFFcfP9940dmV8l6Tx2t+5mxynYMerm02
y8HuCs4nCogNmXYbjRcd3h9q3Lw449+iBKnJsALfennng9WzhetCESpfeDuJaTRIMyxk+vQt
wyEofFzhKSMZ8rb6ZhQpy4y6YFbG8SAMB4C+OzTxfPH+6oN/Jkk5cTMz5RMZG6VUq+MDjjA6
WF1kzR/mYj7LaaHwTShEaQOxHgVrcsjXLsW0vwp097Z920KK8765oOMc+zfUdRTejVjUqXLu
pnbgRHqf7TVoZ321wOZK2ABqDmU9HQscoLdAmYQ+oKe5oneZBxomvtFEof9gpcVTNVH6a9kS
PbYz+ph5RxNLN0Ro4fAvzX1yxsKfJ3W6vPuBHHIe+mchSvmc+rq8S7zF1LYZj4cHwRqc3E1h
IjKnPnqvjaXntV4y337WYr03O0yzrJqNoVSNjsGNxu1GOj5neVofj7uvTVrmrqUoG/QKAH2N
FR/ItmAVtU/0BgjjA2/G8GQ5hlXXzmOmBmQebPgvQTUEw/qVM3ojhFx4b7sj9Meh1oyQ/puo
LXr4QLDTUZl4Bgy8nDOBBm4qi/Y9ktM/NYgzvZPIrQVrgK1m0jF85lDPDKngI5eo4TkTYuJV
YksiSQ5b0lkSSDcnZNdYG3KPGpX6xybO98z87xZa9DykMfPoxX2o0Q21zEarRcP1nn+mFzu/
Y9nmYc591+06nSSembHnNONLRHbW1MiZARPT0/SxbUMxdpANol+rDmMVtRfEznijhLm1sjjy
vQmJC6kfWvJs4SS9sJsScy/ZB2v/XDjBHUJn/oMpRBL7U8SeoIgmmOfD21Qe5k103zXnJS0W
csn8q3TR3OhCMWYDGYTwHTiDGDgcnFfY69Mdja8fl2J0y789mB5fE8imY4ViohqZSl80a2zD
6MEeozmssmtdCVLmYvfCy/ROqCmuRYRf6+uvmtNcv2eqbYnJmU8HP6e01BcU/BuHvd1v7jj4
Aw1EMbohZ0L7+zqs5Kp2H2yGJlbDtyqD0/Z4GkWp5VzZQ+QuOx+RDxD4dmbLKSW5ILFZ5M2r
gM2f21Mg1o+7fXc24FzmJFNpQOT6u36J+BYFSWD4okRRQAuBYMXUHzOOA5YOO1pC4n5OvO8T
Ev00tOcglaAk1w8QnHug+aBcsWSCZv47ICKZMzxT9hvkdX5Jp4HOyqHn/L0cfvcvGxxz/708
U6SJCPO+o6dlWjtPcFqIfi+l1Gqktw6v32phZ+utCruLJNE1hBmDrGziID+CheS9NQmYNMLr
MdFFlNjkso3Nrw9Bsts+6Weyz89vL221/xcg/VfwuP2+2zhHu8CgLD7c3Lg8DahmV9EIfH09
HIoBatoJgTX+qq4IPrvU8JxFgrtv5RzwuHupri7hX+KHNvRo2f4jVbSsShtRjbZrPNxsaUMF
334rwU3ptwIoxBMczCQbhvDm5xlyifafhLCML9wTAKpS/aNSvns7tnJpxA/iw+678ySnjCKC
f86gjPKIkeF3re/C1hHrzv7L6NfN+vAYfDnsHr8ZA+mfVu42TTcBH19Or+zLwZRmJZ26y7dQ
eTn8zaHOrZAiJhmfKILB4jPsEybyJRHU/jLKSBnJ7vD83/Vha05h8ZlWsjQjxR4LgitBOobO
g9yO2v7kxZkx9ZT6xs3w0ltngkO5WhnMk0pdV0LPblq/m0GSMoEbQHst5fUdlz+6cGh/UEgf
5p19UNG9qy6r5ldKcNGVzuzdFufbXakNTJY5GwHzHLv1tjV+OxXnRJeFhX4cViUJnjmNSmgR
2UctziWQCTu1v870dkR+r9+I9VMC84hSP7Ovs3xi972sp+pzBnfPvDjNGfa2+/Lm/r6m/vZ3
YDuAY1debJ4yHd947QoPqduwOHimCIbiWIbgkeeHFtqpLnCMoL9qsHuGi4UGmOufCPIhJBNJ
j+l6NbgqvG9Qvru0qqsn9q8XX9eHo/u8UMUwTZ/Mq0f3J4MAEUb5x2tQrkH6u2hf3fsZ2FCm
ZjmBQHbiZj2iU8L/0kaTaIMtZTaWxaECmza/2+KhGr3kbHVhVFTBn0FuL7qZX8BQ+v7Jk93N
sv9x9izLjSLL7u9XaHVjJuL0tAAh0OIsECCJMQiaQhbujUJja6Yd47Ydtvuc6b+/mVWA6pGF
FHfRD2UmVVnvrHzV8afRacv8Bpau2WUYeGfpKhEAWg+S7Pbl4zT5+Hb8mDw+T95fvp8m98d3
qH63zCZ/PL3c/43lvL6d/jy9vZ0efpuw02mC5QBelPWbtAvLife2q0Z3icwPNaXjyXTSepVg
WZTZg60SRcZihYUSeYRbnpxnRYyxiKuFbUfclfp+qKPic10Wn1dPx/dvk/tvj6+TB/3M5VNt
lalF/p4maawl+kM47K9D/j9ldKAEfssteeSxbUrjhrmM4DbJU1odHLVwDeuOYmcqFuvPHALm
EjDc3jCXqIGJikRkKjLaBkc9FdfRo3dNlqvFQddrgLLQC46WLN025GIaGbkuxcfrK97pOiBP
c8KpjjwsUBveEoXDFrsQrWT69NncMc3nUwITXrkkGd55uGOlfZ+JfXcaWyyXSADSIqexEjTM
98mcHJwRTVY8ww7RttzeFeVOb3geNWKYpCQd490q8sednv78dP/y/HHkTrxQVHee0YuLVWlU
w5rWlhjL+7qV3gSgtf3wR0Pre6ArnU3J4/vfn8rnTzHyb0jcSsFJGa9pq//ltooNFwRhtdUI
0TJa8d1rmyKGBIp8QHciNl3vmZ6mk/CsfdTTwYWI7UiLsExVNsa871Fuizvdemw8MK4NaQ2R
Po1j6MC/eLqXwZdS7xwgUruhhx7YHnUzhRo3ThNgUKidaBlv5NlNsTVcOHEERTKlClfx/4p/
XbhcFZPvIqD4gZ494gNq9lwuSuYcTl+1KXgc73OelIZhdgcl9n04r9Nl53vkTnXcCk5DReTv
Eet8l1K19UlTlPZt7uAmZUizHUFJm5bgTNa9fs+it8hYYsya7W2RTpg+XxB60LMpcCC3GMPe
TBp5kGAVLWGpMOPDFantQIzikyIg3BuPBEIjGYPB2RkVDHEIJWlskUhWMV10H2DZz065a8QB
+Ph+b2qEosR3/faQVHLmXQk4qFn6W9muKO7wDkffg2K28Fw2m9IeRpggIgfpjd6M4K6Xl2wH
134QwPlN1H6Pistsi8oWupoqYYtw6kZkVHzGcncxnUp+fgLiSnl1QMpgZc3g/MxdOEEVUbND
LTdOEFBHa0/AuVhMJQvtpojnni/JVwlz5qH0m2kHXIs53eBelaxSagLGbhciILbQFHbfgnJF
FxjofZdyYu2webqO5Mj+DlxE7TwMfAO+8OJWseB2cBA1D+FiU6WstdeVps50OlM2WpV5kS/6
9M/xfZI9v3+8/fjO0wG+fzvC7UPyx3/CnfkBJvbjK/5XbnSDIii5x/4/yjWHP8+YoQU9T0D0
mopQBK6oS0kabxQ1dnVbRVv9hO7lK3nVCmEqZlkvUhhnJSIxxZWkdYmyhCeZl9NSIJVut2KK
6YeTKDmDOMSI5+RQrndYDdpFzmHH2uTj5+tp8gv05d//mnwcX0//msTJJxjrX6WEOF1CKqZc
JOJNLaCU2mpAym6h5/RakmK/J4yVhMBdD2xRIWm5w3OSvFyvaTc5jmYx2irZ3TZW2t70E0k5
+cUXVSZGw1bkKiZHK+N/UxiGrw10cK2uCOfpkkXWylhdSd/2EqzWhP9RO2TPE9LJlQneLEEu
HMcVITwZrMHkJhOc2ljcrdgmTrQ2CyC/j2DOWxN7iNFII+HVSpEi2cdoge9p7HMAiZHLcQqY
deMEaXu3Lcea2fmhksxuLEpJGF5SNhHLV3WP5TDTiKYMa3cBtJa40XeIzaFO5FCxHrqpQJw2
wWkRG3UDOMp3Ebn9UZvdIKXIua4ZpkfdlOrTFl3K1GWJCRYtr1wgDYy/7MLDy6qKIQQmhtvc
28sTJieb/Pfx4xsU8fyJrVaT5+MHCOWTR8xP++fx/iTtw1hEtIkzcg5yRFbQGkb+6TqFuwpl
E0QkWw1vESAX9zp79z/eP16+T3imcok1pVuWhZbIXGhns/LTy/PTT71cNT8RfN6pumObLI8d
aMwkxcb05/Hp6Y/j/d+Tz5On01/H+5+ELoBIaSjDCpFDPEkbJdIAwKgGjmoFhOfg1IA4JsQk
mvlzBTZcI5R7T3LgDn9k6kPNVCh+m9b5Dt6Jwcw0bKt0/OBBs0rGmiFFmtZfScGNaE1G4hTJ
vrDWxwtZqdtGT96pkotoG63TmqcXpQ9MLCTDhKQZU3KFFehuyKAJaPlTE9gDbgdHdJ1Vau5k
gPO9kjZ8FRhgUuFbIjZ8s8m4VvY2w7xctnRpWIueDu6M4joXbVwTNPAw9Xcd6Zzr5s8zCh0B
S8UExqPP0DzJ8/grGJyZWtFf07q0NWXs7svHMo/u9PHd0TnYCvHMjzJM3Oqkfb/Ko5uUWg+A
Q82VnOh0APU6rRpEBh7oy7K1Vm5HqF2KlAlgcxLrepQPnjpQcvJVpU/RSkCU1F27VYVdE0NB
Wh5ZhOFjT7IpFGGVKnD3zmiG/qCTrnqoCMpM03TieIvZ5JfV49tpD39+pW5+q6xO0UeHPFtH
C5H0EzxZg34dF2w8v/74sN5FelcfyUoKALhoJnTWNUSuVpgIP1fcrwWGccPcjaKcEpgigh2i
7TCDBe0JH48Zjr93ja0DKrdTJQmFCkcHETlTmoZlcZ2m20P7b2fqzsZp7v4dzEO9E34v7zSF
loJObwnW0lspY7noeruSWnwCy29ZRjU1fyVmlWMMAdB4l/hE4HTTsIDGd1EVmQWlGMtDOwsJ
glvWtm0U6cV1DmFaaXDeRRXmE7QUOfQt63KJd/AecoBDSokkPCO8hIImGQGNy2UdEfD1yqXq
hE2lsoAPBYmB8zpPC1khN+B4Rv1IfTJmQLIsgdW+TSxeLANdUyRU750r0eRhDXFwPZdA7vH1
Cvn0GjBocs9FFCrBNB5sZU05Nas0S+UJkTMOs8WmVLXNPkvgB4H5ukm3mx01hhHzp45DIHDB
7sjh+rLP5PiMAb5iWTRf6ouYhzbLb6Xx392igj6My0KJn+++KnfxRuwn9qWsZPgVsDCsinDa
Hsqt4u0ukFESODNjixNQXe3b4ZrYnffFWRxhBB3qeWNYq8j3COGyiByfUqJ2O57XTkHybBo1
+a9AQstg64AL7bK2vJzR02Uxp6z2NdELRdQGwXzhHTZ8ayHQ4cL1hx7UmChixwtCD8sWfNqH
p4jCmapKFghuB16maUWnDT3TJCmGRtU6hxzHe8Es+6Ztfl+M9D/cHXY5d4gSrbcyELWVCwNf
pTfE5Nzn8+lsKniwlrCziANVvAr9gI567Sj2xaX+QRJLF/DuqUuQn+7QwlAmI8UkUeCG064v
DAkkiRZT3zoTEDv3zKWhEO2L0HNw/Zirrs29WUssOYEYPfCyL8ydLyK9TADP3bkBjovIE89x
aFV1iNGqkvqW7wC2LkL03B9HBxJaY4ErAysM2xrrxRpf6GDVedGZBbHYDfrNgSinLrKZJrpz
kLbrcRgrqLOJo1ayFamH8L281OBu0lkOdHr5sOkgrg7xpgZkZrC58uhoHYH0yXfGBMrvZcrN
8e2B+69mn8tJr77uaLVG8Z/4d2eBkuwjiMizJS1CCrTIPKKAOpMJfKVjAFSIl5e0SqI61gVV
jaLMq/gQVczywKxow247yywCr6DgO4jC2E7rjXVUpNobQx3ksGW+HxLwXDF/UT0/XNOoS5YQ
9b8d3473mK3FMOs28t36VmIM/mFlzn1qt0y8nSlHTDU9wRm22ZswoDuD8YmBRHG9wDzli/BQ
NXfyo5TcwGgFihyOPD/bWbudgEzDdXzofm1cP9np7fH4ZOoNO2GKvyoVq7tDhwq1R4w6H8jn
TxzxLsrl5iviUt2VERVLmK/51KHdr3oqFIXGCIqUlXQoUEcQ5xULHMeiLBY0hO+OTsJdny8S
HJp4N0ZkVVoLNIZ95FlDe/f3vG5gd6ZU2317lW1ZAkrT0OhEZrHfCPRtE/qWB606irKwvUIt
8HB7aTIqnr1vVBxv28pgW4DN9TOgnXnG4KAimjTgrFbmftyyYpnWSZSTOVq6WSh219+baK1G
5tD4kZ62UB6Wd+jbcpGDsdp5eSBv4/4ovRVCEC2jXcJz/TuO706nNiZlBkeXYMtgk4kszkc9
EZwAB51Iq7aOqR6DY4pgwiTa1gfRdEdDrhhMwKrrOr34M/JyLZw2267ytCUHQsOPTAMGkimZ
x2PY1baHr47nk58Wnv3Qxm9v0+XO6Gpjxe5Ht1VYEBb3TOXM0NjeCo+ARMRUnVWgBwy6I6tb
l3myyjBtX0PfiLeHtWVz2u7yXP+sP3Nv4/OL4CqL3MNBdsyV4HFT8xJVWaQLWCYGM4O78UG8
xUqrjCJW4YM5N6hxQ9ql5UGNbRUXuFVdJOwK5NnRTLIzW8suGEkovFaR+qYtyB7iwU3TgCmM
jveEZHSeIXfbmEdok++SYDwdRqDPlCcLz9CZ7CYW1253aetDOmz1D5aG9LZQU7Q0MfypKCdl
0UYQ1Xaw3NCFYghuO6fDNSvi2mE4Mkx9vPK8uBsfuGoYlnupgoX/ugbjT5gqseYILna0OIA4
EU/HpTcrDdytdoRZAbiPnv56eXv8+Pb9XWkAf6pmmTU6IwiuYjJ/6ICN5I7T6hjqHSRxDLqi
0rpiy7LW3yQuybd42n3yB4ZsdS7xv3x/ef94+jk5ff/j9PBweph87qg+gcCJvvK/6hWIVWLt
tahZ0P6VHNm2GS3n8SFHAxW6a41S3JRbUpGD6DoumJrZic8PGEd+UbKWm0S3mRbmrOJTfHyZ
R32OuuRw2mydxXAnsOR+BYpRVjbZegMCnU1PLkgs/j6IzApLSkCOa+E4tolsnKKsvNa+bH7/
OgtCUiUKyJu0qPLEWIXN3B8psWiCuWufMMXtfNaOfd7S/nGI6/Z9K75Eud3+uVXq5kjLAY84
WMyXZ0m1tTNWtfY1IhyMR6ZqnWX24WVe7M4sd0KO3xwK2MFIMY3js6JJY32IbS9PcRTIUyuL
AnXAB3b83fbLDg5Y+2IQN8NlVdgHC2781SYbKaMnONAeQ0iCryhHTWaR1ZFiX9i7QfhK29G5
nbc2rxYjk7iGw9/Y69N/4NB9BkkSKD7DMQb7/fHh+MpPYl0fwfswKtkBzv5e11Z+fAPS88fS
gaGfBkXexlVO2nCx184OfdLRRh5jyjTLI/Xd+AHYOWnbpicnwWDy3dY8hoVHEC56y+eCQH1v
7gwXcq3SENMfIfMs1+GKVCoocemMC7ywt3vzQPXqR0TBCm4tgtuY5WFsRlVRVYomG36ajlRC
OK3Y5P7pUbic69IZfgZiKTpB3eATP7VeZofkOjGai56kM54Pdf7F31L+eHmTqxXYpgKOMLzX
5KepDo4fhuivJNvSVXgXvir7A2gESZNacV/KmidwFCvqmb89Wm3u8mw5Qe+Nre3Vo48XaDnG
K59g0T3wEGpYibwh77/ZmoChCaFbqRlNTJJYO1B6wd7oqaEWEGvg3iU1Mtsqj+whAfxPUgJ3
ORfOiDM/ojCMq6XGuMNyW5NLfVfEleuxaTjyMWsdf9pSH8Oh6Pr0PiiTBOMkNl1cj89RUYQy
krE+apin78f3yevj8/3H2xO1H/aF1NCFzPKo2cDrKj6kRXpLKxtkqjqMgmCxoDM1mYT0WUsU
SEsBBmFAm2jNAq8sb+FfTUiLhSaH4ZUFelfSXVnvYn7tmMyvbfL82qqvnTbhtTUH1xJGVxLO
rqPzoisn7OxaDmdXjsrsyj6cXTltZtc2JL62IemVs2FmyZluEi4vE7JN4E4vNxnJ5pdbzMku
7yBAFlgyBRhkl4cNybyreAt8+uqhk4WX5xQnox9y1Mi8K5YQb+lVoxC417S0pfMB2A41EZN7
eng8Nqe/x468NAORrmhuyNKtBeinfoGaw0gVShAes1mQO74F4dkQC0kLiuKmkkyvA/BgcvQ4
76LNfcfVKbL6S7yR3SO5rT3WNI0D8HBLvR/A0Z1M1QuT3YPe34+vr6eHCdcGEV0rUnA0G8sB
LOolzK8yPtlHldb2s4BHxP5wAqt6iWMzMgico4plOGdBq9VXpNuvjhsY1RQV93yz11S0FquG
QFpeief+EBYFinC30m7MGhYkbRx1OwXLyhGmW+zeA6O8csSAYiiOGu4pujVpPHfmtZaFZJ0w
g26XQ0//vMLdhJxISeXDVWKkQ6M28Cx26DOBO9L0Ko4Wvt4Cg4AMS+/Q6GzXGl3TVFnshhat
laBgs4XOunRN17pGrMFVYnaZ0WGutpPA5Tv7CjdKDSqc7wzGhULUznZehYFnXbvDpqhPX7/x
Q/poEPMzd0OLSqbrTjb3F47esg7smt3/pWjVg03BCv9K4yvhTGj7CrGdu2k/xc3x4ON0+/j2
8QPuz9ouqYzJel2n66iR/ddED8Ja3un7t6mSIqvov9lLLnB7B+2U/S7ufPrvY6fDKo7vHwpf
QNmnOWbuLFQ69YzTNjjiW2dfKNV3CDUj7RnO1pncMIJDmXP2dPyPanyEkjoV2iatKSXbQMA0
O+GAwPZOaWlJpaG0AAqF4ylNlD6dWxCu5Ytw6lu+kJ0XVYRjQ3jWZnveIa4tIypRhXTJvpyM
Q0YEoYXJILQwGabTmY3LMHUCcqNUJ4UkR6LDK2YUJp9/EVi2q8RTXQRUD/Sukkjgz6DejV0D
d/7IGHe2UxM7CwQnp7qbby56aagV1mFoOF7zd8crfzp35DqWUQMr6g7z7oeLmW9NNs+J4r07
dXyClZ4AR2suDaMMD21wkh+OodxBewImx3j2DVSAPeXyC7oht1aEapPXkZvkix2ZNIcdDHSD
r2bfFmQ74Mj0KFFAInB8omtgsjiBduJoOPqGqBC55NnUdxefkLL7dI/AE5uLshpcjwg7F8QD
j0l+hjIbb25RdZ1J4pkzd6l0LRLLzswPApoLEUUy9nkz9+QJ2sNhQGeO31oQC8sXrk/0ESIC
+c4mIXxbHX5oqcNfhBbEXPVYHJZAsfRm9G2/J+Ei0HQxNivX0W6d4ni4i5ljTs7e4crE1I0/
9YgZVTewu/gkw7EbeNSVcmhsslgsfGWn3+wLi78uP9HJ/Ld7fFgmkQMPe4jm7TqAt+U+uivl
TPkDSvhriZQq6RbDxxKCCt/K4EYTLETykBwIeDYWWogYaqq5IYrnxBclGSr7PT4e/vDy16R6
O308fj+9/PiYrF9AvHt+UW9IQ6HnwmAozZRuQ4H20FZWrpqhPLIF/LLgkjQyhS8PjPLx3Lv0
8dwlRhXu4SvXWRYxjfs6nS/IKrvTdrRN3ZE7StPlCxul+ZplPH5mpH19fA3Fan/1Ga8kgoUA
QoiHPoHjhM3CqYuFO73QMqRjUbG4UByQRH4yG2tcDHc+TCpONW7V7JNm6lzgpfPwuDAF9+P4
tFp4lzoH3WPGKaptO5tOw0urgXtejRPdeLBPXqCpt34zdy7Uxnbb9kI5vbfoeDlNgX5SLbAV
j1M2LHAtpZ2l37nc2/KYi5PbvTCcWdHCgk8s7idFG+zyyoovyha9qW1o4V4zWj13SbIWjxEk
h3W7XI4XIugukCQZiJQ3FyZU7343TpZXsRNeGubOkGttXI+vv0Y2ks6neHw2VfUFituMwf8u
LYGCxZ7j0bvnuTLMyay3qF9nXGGFSEW6josZXxGWJvZOmWMEwdQLR6boukpi+xSqkGUbz+jM
H7mOzvSuyMcWHWNLuAwyli2VyBe2VH7gyJSFChJO1JjMiy5AIlCOJsB0r17o7p/nXoqIIhGs
jYbIJYaPt9i6O+rrKrKK8iOXSdb4+nFcbI1KrmC3v9sLleqPp4/HP3883/O3AKw5tFeJkf8W
YSLUcV1FiSUbNNBEzAscSiQWjlGDxlb9KGrcMJgajl8qERzhhx2jI2iQAJrrL6bq1YLDk4Uf
OMWeSpfCC+ax6ZKkNcDU6zXCTY3vGWrLU4K9qVvJBqAa4jKAQ0pVMWAXRg8KsOVpED4sWUxd
Lvmo8Iu+0W2dEGxv1KBS12Bzl4B5BszxjVagXeZm6S082pDASXgWROEEZOELcyooShMJqEdo
c1Tlzl3agsfRLVRXj815ONt9kCIiMivKBnNE8u4/M4QwYERzxcaieMw9pfdA5OC9LcFEho4p
BTRmFgfPp7biKf1EB+cSjr39nMDiNHQmIC0UZ/TC05caQMOZCQ0X04AAukZ7OXgR2GsFbKiV
pClZethCr7G/qel1bpvWklYMsXB3pcNjEVnFKx8WCrVMOZrnK9Hrq5tZ6NGqKYFGnYalxM5O
ZWzzaWxzweXobBbMW/qAIOxaKkHhT6nDgeNu7kKYf4ohJlq2/vTCuQCn0hxTCMfkOw1IcIeS
mc5rg4+PeJ7fwsqNx1Z3XnkLi4ORQIeBxWjbVZMXI2Me5f9H2ZM1N47z+Ff8tN9M7U6NJVmy
/DAPumxzoqsl+Ui/qPKl092pScddSXqrZ3/9AqQOHqAz30MfBsALBEEQpICCjF2Lji5nKbvc
hOvLUZSmgFkeVPLmOYF15Y3uNFW4sc/83tPgGZKHgU2BmNeWEtSloeYWCxhQaJ7iWu9O+Wrp
mYIwo3kEGS37BVR2yh137RGIvPC05IS8bdtFKt9D9YtlCUjtK3xPtjz94X0rfGdp37IR7VCO
ToFEzaaNtTD1GcBW+u4gvEUUzJyM6RbYgFEj5j2wD7jtTqvQEohA4AvPBdHjXsN3qDiNJXmW
INraGzol6cZb2cR4iFKlzfMQuooY9c0+SuGEWVgiH/DSCV5hoSojA/GPDrNJp4437tfM9anw
GINJ7tccmMkWk3Wm2LIzHH+PVd5FOzmgzUSA9/EHHkShbA+FfDs300wxRmUqojtgg+xoDaLQ
DDYNUQHe9oUBZR5LNKnv8ZVAlS/hH/rtkEQkZvt6I+OxgSg/HkWuVqDbzypGtqIVjCsrWA3j
UJhtVPqer95gaNiQ/GJwJlJfM8xw1uZgrFtqBmTgrh1LWKGJDPfXNWUUaCQkP/htn2USEOfT
7xwkoi7x/HBzvXmgCdYB3cpoNV+tAYlg47TWYLevdTIy2p1CFAarDcUqjgpI2UFUuPGs3UOL
+91mhQFOo1SrTkNuaOtJHzm5L+tEVwYBhwnLbquTue+0NBwldQtYpViHlNmt0gDPSJbVYehv
LFUDLqB3NokITiykE0YjoScMMPIzHRUjB6PSMLTUaQcqFbNZ06OsY0ZaxRJFEm20cIgS8ggK
Lbi+UjhNeK0C8pZZojkVdGHubG/qgoofrVEZWW9l5KGN+6MSqmMmaKK2jrOmua2ZHNwTk3Gw
8pYsYR72JCScIsmDmUwSOIGFXYBzV9e35Kb74DreiuxZVxxdUkSgULC26Y7WLerIkihKpWqd
d6n8IlwH9NMDicp23S+RzIdYE5fvwOC32TXCrI2rCp8JvtcRTntssm18oL+H1mnr0/t1cuO8
PxaW0CsSKYxxGby3rwNV6K7eU1Wcak2FPZ1p4EToO4FHMtU8J6s416J9xMnXtawH6lxtIdrY
q3fsXVaPyQbOIvLj0fhqt/TjnYrxyWb1Y6KmifIoZrF079IkevDLpFcCq+dMDWUV11sOw9RS
GfU0rknG8LRy0M+mL7OEiFvLtZkEn6+pEBOMGPomq+n/PCYUyUzQVuUt2WwblbeVpWGe1fl6
vUWC/u2UrPpc1CScFVVpYUFRmAjOyOOQhl3uXlZa4iI0VDwaGc06ONQxKze3GGLpxoa1hycc
kX1nCZ3QmF8tSYJxOFadveYTK+MK86Ha+92cLU/6ONMtt83JlGfBVlR89GNvVjzJtw4ZIxFb
sI09jEcjnk1YpNnIuD4BRRjPgnW2PQcpGSXNSabrAISUVce2TF0a/E0Ax5Ivr2c0PkbWosHy
VvZrz/JFIaKFDEV0tB4ksIby4W2KwJdgANAuAU7T0d9aCZwtGB1ijZiZypjn8VJgzPnRUZxs
D3HaHHlcrDbLs8R8VMc/6hvdRZg/T00gKxgeFTzFoGjM2keR8KDvjrbe4luODgXpSM2foGmi
lAfKvd5Umza2Rsbv4OxN8KfjRAvqh44qT8Y2jizNUKkf9WbhR9dUeS7r1/QYj3I/fPzy6eGy
yh+ff/xcXL6jn066SBc1H1e5ZAfMMNXbKsFxhjOY4ZrJAxUEmPLdcOlpNMKhV7CSHxTKXUYd
pXhL21MJ24fUCQSO+Qilr2/MMUqCNuf5MjmgMxL5p3g4bTUMCbW/PL7dPS26o1kzTkShZVFH
WEl+BMGpozOwL6o7NDKcQC2W3pYR3oVzrlH84kRZcTjj/RjGLIGdAONQaI8/geqQZ9QUDSMm
xiQv2ukthmDAmBX98entAVOM3r1CbU8P92/4/7fFv7YcsfgmF/6XJoBwRnA1XT3DCeHk8CIr
qrolSxRRnleKeQeVzGtUvEmhXfNICDW78OcqHbLxH1WISuM6obr+jY+nF3fP949PT3cvRP44
sZrQHHCnD4OjH58eL6BH7i/4Adz/LL6/XDBPPcbGwZAz3x5/ElV0x+iQqp8fDIg0Wq88yiCe
8JtQjhg5gLMoWDl+QlSIGIsrUVAUbe2tlpRrQ+CT1vOWod5i0vreyqeguedGRv/yo+cuI5a4
Xmz28ZBGjmf5AkRQwHFkvab8CTPa2xiqs3bXbVGfzQa5OR932x6wpHD8s0kVMWbSdiLUp7mN
osAPQ1m/KeTzhmGtAtT72gmNCRdgjwIH6odkCgKNECsXkSZcGTvTAMaiZr1xFzr0S5kJ71PO
0wkbBHp7N+3Skb/XGaQ0DwMYQmAggMdrxzEYJMBnQxDRub9eGYwb4cMotcVa+0peGwnsm0vx
WK+XS4OL3ckNqYnpTpvNknIMS+iALkbeBY+ifwYTeanYJFxy7xTBlq1AiW2km2NY4GfXD1fK
V8Ca/EoNPjxbl8WamGIODn1aeB3yG3QZbynorezc5fgNuYp8+epMAVMiEqUbL9zEBvgmDAkZ
3LehuyR4OPFL4uHjN9A9//uAacUXGNqVmLNDnQarpedQBwuZYvD1Kk2a1c+b2u+C5P4CNKD8
8MZ57IGh5da+u1dC7V2vQWRbSJvF249nsFaMgeEuDtaZ66x9Uj/rRcX2/fh6/wA79/PD5cfr
4uvD03epan0G1t7SmPfCd9cbY0FrF/zDmDE9Vs1S/QJJSrJu6YoYes30Ds5j03Gq6dwdSn78
EOziiXkf/+8BrUfOEMPU5vQYBLRWQ3XLWLAqHD2DhY0wdMlrEINKDQphtkbe8GpkmzCUn7TI
yCzy14FzDWkpWXTuUnkLquHUKw0DSz6dU4lceU/TcI5n6fOHzlkqD6Uk3Dlxl25o69Y58Zek
+aYSqeHHlW6dc6jBb63j5vi1/aA+kCWrVRvKq0rB4moO/Osy4ViezUmE22S5JG8yDSLX1hbH
vjePQ4eslWSr95m+TWCztDE9DJs2gDoM38bQ/iHaQDdpZMtcx1/busa6jUOGKJGJGtiCLE3D
fHtLp9laBLVwUgc4KBuKBj6GgSn5iChFJWuw14cFHPEW2xc4+EOR6bzLHzy9voHpcvfyafHL
690bqNXHt4dfF58lUuWY2HbxMtzQRumADxxy7gT2uNwsf+pHeA4mDa4BG4AN+lP1CgmoowJx
MXH1Qw3vngcs/e8FnOBhv3zDxBLqQGXXQ3O+0Xs5atbETeknt7xbDBeizSVShuFq7eoVC7Cy
ZoQ74hj/1v6zaQHLceVYAgJNeJdalrwDnSc/GEXQxxxm0Qso4EabCH/vrOQL5XFG3TA0JzoO
lpaQSlOxq9LFReFqeSPukTqF4ZJ8KTJO8HIZaoPm+60aCgPBx6x1zmQEAV5o0BWpo2wMM0pM
mEc1ddbpI1xRmk+UFw8o4JoAGtMDUqo+bucttbAT2lZh2uppCLnkxGEQOXSQv5mlqjUyyXa3
+MW6FtVprcFUoXTuMEB3TfAHgC4hqZ4GhJWeqpA8WCmBZOZxrLSpKc9dQDGl83zKyTQuIc/X
5j1lMTK3iGlwojcAiDUibFMl0LVR28YURjGuUIVmiSFwuLK8wJCt1IWdTvfXI3Tl6G78j6kD
Gx86dat01NAoBcmgma26GFda6BpcFl23ZEqQCGxLVOia9eRp7FroSXl5efu6iL49vDze3z3/
fnN5ebh7XnSzlP6e8F0k7Y7W/oJUwAFUE5Wq8R1X364Q6OgCGSeF5zvGcPNd2nke+UhWQvua
KO9c7RXRtA6W1CNMxEaH0He1PglYD6Mm4cdVTrZBmpLDPh3wx3giWF+b/ifKYOPaqgURDw0R
5yrKXbZKa+q2+l//YRe6BL/Vsy1xvp2vvMkMGa8gpLoXl+envwdL7fc6z1UBquXM2fOWAaMD
VUruJhy1mTxSbZaMlzxjoqHF58uLMCj0wYAC9Dbn2z+t6ygv471rM2k4UrMIAFa7DgHTpApf
LK/U58wT2DrHAqspUDw3e+aKacNdTr9InvDko3FeZRfDKcKj1E4Q+D9tvTvDQd8/6oX4ecSl
zzS8se1m6RkD2FfNobXkieWl2qTqXOoLHV46y7NyujhNLt++XZ4XDAT65fPd/cPil6z0l67r
/CpfBxJBV0eNvtzYFEZbu8RhxDxzqHdD5kUQb3X3cvf96+M9ncypOPesPhw924dJaSN9mp7i
FVUNKupMpcPiWJ7FoiC3UUDfFO2QFUsvuOUXxllxEBlZLeUx/VcPZ7e037KmwFRJRgdqy5UB
IndZ0bd7vLqbOiFh22SfTdsofjQ8uDcXsMwN35dUTmQHA/OAujcYCVqWO8FKbZDnDzrX3HG0
Cc9XkGoYy2t9ExtvUyhp30YXpwRWh3CD6eZYW+cRlYsPKY67TBOEI0ymCqmjMstnFf36/enu
70V99/zwpHRDw8g1xA1L5S94plpnjFL5vPbil8dPX+T8v1hUvP1gZ/jPeR2eNQ5P2LSWuWuv
Wy6cdWV0ZIb8D+ArkbC4pHHnprG0RCpgavRVg2lN+MroPxxYczNtvduXu28Pi3//+PwZRCDV
kyBvQdEUac5KiacA44+cbmWQ9P9hYfFlppRK4M+W5XmTJZ2BSKr6FkpFBoIV0S6Lc6YWaW9b
ui5EkHUhgq5rC5qL7co+K1MWlQoqrrr9DJ9mCjHwj0CQewFQQDNdnhFE2iiURwZbfGKxzZom
S3v5gyNsMUpucrbbq53H56SDNlKrwTRQONRO5JU2J/vrmOCI2GGQ99eSJgM+auhH0nwu+WMX
G/oApwd6BwXkLqYfaQKqPjaUfQcYDNXG86SpM+6kYxgEuZpTEfqW4K+IdSy+CmRpQQYZQSGN
YXM4dytftnRxNHOoPbmi4XNCuq4iA+aVVZHpEtfA5tXuM/J1Dw63xdOc6iTFF7VMT94+6Cly
5XMhiO/u/3p6/PL1DazwPEn1zOmTdgAciAnmohEPbuehI0YK3T5AJwnWS00dniluutT16W/O
ZyLxCTPBjpmkPpEdMAN+zLjhU66r1YpwUiJwIFGFNbD0TEIEglGQYUh+vqPRrC0VAGcCb0ld
kGo0G4o7eR368gcFM4YKUTBjbVF45oqPMOR1XtPF4zRwyM/spEE3yTkpS7r88BExKe3vyPTY
0j7lnyMN9vnz6+UJ9OOwoQs9aS6D4y4y85Onh6K4fQcM/+aHomz/CJc0vqlO7R+uPy3yJirA
Pt5u0Vlp5iIm0LDEOtgh+7qBra+hbDOqUFMJU0FSZWTVwz7VRTdZddSy6l7n3aQnqp3yJgx/
Y/5sOCAUoAPJ5S/RAOctjk6JKMkPnasHIRi6aRxtxo611aGUrBf+s8fXjuorQhWOkTlBszE5
GJdSS5n2Y2I6CVQnaoG+zT4YGhXhTXQqWMpUIDSOpx4VWLAzzBSgZOYObSGYEIQRS3RwiGKq
AtXnolrz0Znne27/8Fy1/fFpN+yL+LrX1o+mSvqt0XmQsbhqM47e2sYwE7Gyu9H6rEb5nkBj
Ib3BpMv7Y5Sz1HamHGbrgPEwG2IScTUbYEE9zI5WYgwYC4srOuSdSYAC0GdHsOZpnD4E4kUo
V2779Df+YkU+WE0wZfIxFDoY0/jiFQ4eH7M/gpUhU4klYTLvmSUCHJ8snufA7BxLTTW7Z8pm
Cz/ncOJdk5W7jvrcFMhg2cy8OhDVDMlmjG603x/u0TOI3SGMZCwarUC/Wtrto6SRsxhOoH67
1bsQ1TWZz5bjDsh+Y+xZfsMomURksscvY9Wmkz2DXzqwOuyiRoUVUQKzrRHCmkvZTXbbauX5
Tbjet+QWJIbUMoiFCdlVZcNazfkyQoE9lpJZ0RK8w09AyGyrHPkROq32eZcVMWtMKdiS2SQ4
KocDdHVo9SJwUo/ylNJiiIWG+YfJaus3t5lezSnKbQE5RCvZqa1KRi8j3r/bxqahEM0wYq/a
C9ZpgD+juDHmsTuxcm854YoRli0cLztry3miJTPgQDnctgCU1bHSYNWO4dKiofijlr+2HOHb
rQpsDkWcZ3WUugZqt1ktNWlC8AlOWHlrl8Ei2rGkAGEwprGAaWysrCii2y2cerQBgf3E5V5b
gSxpKgzSrYHhXJ01ujjD5t8xQtDKjqkA2HezG73TdVSirwkEnH5AwWmyLspvS+o8w9EYyjbR
5nQAKq4hGU54M2S0tT4QnpbGJKwxBpdH6ImApWPTReixbHVrVwIS6obb0jZetBEjmDx8Y2cr
kxVDIRmIEXnBgDXr6rKITg87YEF6YTez5IznNIeyzg82jjSFJjY7DKsQtaqWn4DaQlEbgjNH
92d1q7em6hh2pM6MHFXVbaYri24PGqdQYQfc4/u69XRmnRgrqs62sZ5ZWWhq52PWVNjdGTpC
FP3BSW9T2M31pduCSqyafn+IjYkTmOTQdhj3gv+y7fh5rbwtpgyR6ZZBNZbUHOYyarLyJOBk
FbVxX+0Tpjot5REgBfl14YDXYiaMUNixO5YoQjzCLCm+RRq59u3x/i8iLu9Y9lC20TbDjD+H
Qo5rh7GQ+1jNtw1GwwgxWthfXt/wsDretqV6i2V20nQO/hIOLGXrmKA9V/MEMyQSrrN5AHCj
jrhBrViC+dTvT3hNVu6y1OASkFImKa8hgtVP+RY5krvMltpoONClgJ4JDFY65RQvR+0Hj/Jv
yZ0oeFHFsGX2Hw4Wn69M1EQfbEMSKf30Tg1QLXAXR+mJcMTIMMglHblvwvv0J1sD3l9eGyzv
j0/tGxM6UD2SHD6EJcTtiFTZE5EaCYiDhZPT2qIavYfDpqgX9nHEqatFkVK40Hn+RhcawtUp
5MYaJIqjy9Y1inRJhGFJbEW6PPE3jnxRN4my/9OorMJHQfaRThFur6w+/obj30+Pz3/94vy6
ACW5aHYxx0OZH5gikFLei1/mnexXyZ/O+YubfqELMwYzDk0G5meYMRszMCChyUAejRVWVVGQ
pqogmkPKqKVZrQamFrdKT3evX/nHVt3l5f6rppsmhnUvj1++UPqqA423s33eGiVJhtHmGexM
lP+Swd8liyPZzzbDOA8wOLk8Eh0tmiBbl0ijNG1EsIirveAujT4tpMvHBn71LTvJfcCUHHwr
oG54MZj6GMDEgE1OrPnkPOOO9J4KFObdLvYqK3fK3S7CpliXsPWUYEzKTUUYkCGCHXWHVZLz
dWZYizXof9/GGA6BWZ5rQ/t/flytLRnhOSMjxzlb0KfrzQ8ZY2xdZwXYCmlix8PpK+8ZoC05
xQeCqgZhsdRx41mrL5Jtn1mRRd3X15CdFXnszxZ9jnHdbcXKuN4OzKS9dzyo1rvY4kBviTyb
iLW0MBzsE8mjirjLPqpjayWCxlna56Jjhb24SJFsZWp30+/ba9jkgw3Lrw6hU3bkHmWsL3YF
ddM7U0jL9sR5pV1ODFDFI7w1pGhUSEOWGKXedo+/Mzisa75xASdHgJmr7TM3NoPHCTvRRwM3
TRlfIqrCqpTAWx2X2R4dKKBq1BBVfH3mGgMmDZk8PT48vyn7Ew8E0nd2nQFwDLxC1YeB6YyY
Hby+LVMv7toTh5MNHIaaLI0Dqi+qYzY8yblGZo+ZMhC0Wb7FwVj2JCTZZ1HdansPL4qp8LiR
aolmIRVH4i7TxH98O6WybWw9OpyH12XzPOMDQtVLlK5w4xhMGwMumQcFTmzCmOplgh+uMraa
P50SJzAMstRGO1rkh66A6dZXpN9QJlBO1RLCODXOImCJ3nTckrftwgAR1z7z6KSM0goErdwD
VUtay0Et4Be+OlPKDzBLvJkJrZ3GOXwwTUcQzxTEqi6PdWAjXi/NjXKo3ufha+j7l8vr5fPb
Yv/394eX346LLz8e4HRP+EbeIx37sGuy21h1+4N0ZaTHH4R/p3V2AImvBY3+Rs+fXi6Pn5QH
lgNoar/tt/UuwkSVii+mZLCG2jqi/EcFMgh6WVdlVnaSBHAEzJUG4Z93azAlLNPABJ4uU0k0
NSL28ju/Eaj5diewGixoBpsh5TQS7SJhBIvLPaPCI4sb/Ryrj4e/CE37en9rVqu7CEa4lgvI
wMOh+kqTh0iN3DXCoybZW569sSxPkQQsfKpiI5XrCOlrVmeqqoHJy6ZXWZbEAVmeR2V1nshI
qiqvEzAqjVgF8xLBiI1JTk3n/tTWrBxUwuwfnaB8N6edxTPNB+2+j6JBC/NdGmvsOpkIs6vQ
RG1W9IfQX5pn4uTpcv/Xor38eLknH1jCScgNPb+3J3qYEtbZSca0lFcopjyDV2hO3I62E2y7
rmgwp6edhJ3r/6/sSZrbVnK+f7/CldNMVd6LJS+xDzm0uEgdczNJybIvLMfROKrYlsuWZ5L5
9R/QC9kLms4csghAL+wFDaDRAArsI2krMEbh6QhBeZWNYOt4bBxkVrYwXqaHDONXLc7hCIFO
txmmYE1+Pj0dqwO2Q4OhSWU+H0zWQyfL0H63Y4O5bsY6Cyu3TsYmqxADIjI4VO/3uOJwjkWL
UAhJSaQTl9CDU+erz7mQ+3ggbChrgfVAU4H8lAIbCP2pe6DiWDoceFjFDchYbT62BNcFpsms
xgYXVbuRhbiQyC7K6b72BHm7DEXilwoSHMP0d/RVtIEFlKhvDEftVPO6plWaxdkRboa8pmNT
9OiA553CV3TnZM/w1ZBw1G9HV16Dnqj0ecvaCBbLZHTXilt0WLgVrqvT4xmpcZCMuheGGM9m
pWUGxa7nAKMnD84L0aBLoXutzGdOnVWZsTrFTduUkW50xHZQRWiJDZvYME9psI9yp0LxQL4v
tF3k8eVIBSLbWN7MgwRo2wkWF5/gNq8HFySHJfy9MlQPCRvCnsonaZsnfA58IJAH1e39Zi/e
ADfECzVVZ1fNW0z1LrkRHSLxvWrtPgmF2vZSFPmmZenR9REmgdE9OeQjBCr940gNR+egBEdX
75GM9hSXwUh5nGEPLaMDbh53+w2GD6TEnjrB63j03yTHnygsK31+fL0n66tgHcolNcd7EwTQ
Iy8IfXfDoWmrCen+B738R/P7db95PCifDqIf2+d/Hrzibc6/YI3E9g0He3zY3QO42UVUR2WM
5ogVKxaSvBspM8P/WLMMZftTiaqRUfAipY9kSZQHiLSqSfRXfojwPAl9h8oUjQoAMG/6iY9B
0xRlwLFNEVVT9m5Fo5/h99Y8JM4ngqUGbht6fJPW3kKevexuv9/tHkMjgeWA2WJWdHqPIB6k
vKalDx6yftFAsa4+pS+bzevdLfCey90Lv/Q6oSp5j1TQbv/O12NfAUfaGW2O80pKpxMQ9n/9
CtWoVIHLfD6qKhRVQjZJVC5qT54EJ862+43s0uxt+4DXq/2GpNwheJuIbWDEXyZb/fPah7i5
7eZncLerQzTIWkGbZ4EDXHDeIq1ZlAYSqANBE1UgPwXRee5hzYfebs9F1y/fbh9gOQbXu2Sy
ScG7huZNkqCZ0UKnzKKRBaQOMmGQjW3ygM2Y7Li9wpVQPX4mz2vayi4YhO/AZ+H1hZRKIYhu
1ZW31lz6o/+Bnh7UpdAlfQ4n5m29fdg++dtUjRqF7d3N/ujg670l8dX+Kq2TSy2dqZ8H8x0Q
Pu1MdyqF6ublSr1i7soiTnLr/t4kqpIa7VCsMB/DWARoF2zYKoDuszJatxZmedY0fJV4w6c/
IiYOQXyoLcUwZZoTlAHVV6gMATpvCPunHV5fBUI3W5QRfayS1FUVkONs6n4nxCll4E7WbSRu
LyQ//rW/2z0prwLfbU4Sg9LNzo/NuxcFt52yFNDIvu0hjo7s7I0DRqS8C0jKA80ZGRRXUVRt
ceLkYleYPkUZKJMNpbEouro9O/98xLyeN/nJyeGUqBjvPwOvJQcK2Pfw99HUiqiYl+Jhx6Dw
SRmji6uU5suzdtJlU3zLFNDIuyTnNOtDmwneKRdJ20VhEp6Gj7Imp1lXzM7whj+uQ/3ShpC6
igK9k5psmkfTLgmcOtooFEjoxckJsJ4MYzYacbtpKewAVBZcsl6BT+qM008nBJoSDQ386PN7
JJDOLEH0gs9WtA0KscCS6CBdCjmlE8EJrLxEn9N6lqC4bE6nh7RxCfGgGExw8pso3EGgOZqO
fB6MTjN+SYFUQtTy3r+bBHgz5+RuMtDCKdMO0C3AAcsZ4sy0hFVJ70hBFzH6uBdItfZDVjRB
o7h1kGBMZhH4sVT1giB0gyKQwauTHhsyB4sET25eIBvLkyhwC6TQizpk50WCFcd89wGhSRC0
5K0Nry9FGBwq0hHLupSTPu4sRqMelLUc/NQUwnaJEFcFeEFPV1+Oe8zUN2wSptKTKdqj+XwD
B/Eh1kCzwgJlezhxomWQRndlcdaE24HCeEFdLTi6VvI4CSTswsBR9SW+VwnoiUhQtCEHMm0G
g9bgjJ7xIlBNVpbFHO0hVYR3ooGDCu+83Y/WCqm7JnojIEiVF53jHqCSivGqjFoWOtgaPE5J
hVQsuGpxfdC8fXsVAvggUqlXquq+eljOi+vhigalBoqXAU3ECum+GiV8ZTsGI1qZMrAC6u1C
fxsJ+CnVhQU/nYIC5LTvkBydnr5P8vk9EpR2cM5xnEaoOCyfQoxIgE/hwK1ZNz0r4LhsAkvD
onq3rrGO53l19D7BaEfy9vPpdAJLOcDZgKRmwg461o7w0IPVJHpDi86CrFcHxK+Az61FCR0L
nHhApXYsZhGQTidBSi21jQ43ZjurElZPjiaHWOnIYhhIj98jFefS5Py4q6aBoxeIpOwaGmJx
B6C2dxdqC6RudNAIj74Usy6SJJ8xGLtQSlqfdGzme9ltvMI1hzW07m6ui8ucjqZis6iezaAq
HjkJydqK8ojJI8PVC36gwGcdn8wPWWA6TOlDuYjr0rXuus5Uhs5BXcoVq9wMTSd++iK/BItD
idOCx0BRRmVLSy+SRgvACd6EjFWmCcerQ3eAcJMoAyfpMmC0kzUUuDCKuAw2JPTgy/Sd7gpF
uYkDz1N7LhHuTU8y/sF4GL03xlICRZcnuje9iPLe2KzSU2AwI+Orb1veq6gpVvhKbF5RTmkq
dJFaEpZEEU3R9SRcu7iMe6/xOjQOakRBG4X/1vbUyVgcVwf7l9u77dO9H5IDBtlwFm9zjBLR
luguzm238x6Ft/6UtyhSuNFSANSUyzpKqGBHBnYBrL2dJYyqV3K81nCQ05BuTkIbEgrnEQGt
WivcSg8Ppz4kBtMwpVTz0FMG6gVzBZvAjIHQcNurAH932peRGvKM5zPzpTMC5E7HGzn3y2r4
f+HkWlXoqFwWTqJWUaJeViDoFgFXGLFBlbvMKE1WjVOhBesyqYiOoTOr49oa2VlOESRjNA0+
6LZJUz5x2z5sDuRpZ+ZWkqGBki5tuorVlk9zKq7ozYcJybqdOkGNFKhbszbgCQMUR11K31wA
7rgj4yB9ncXGc1j85YY+qhMO3YWm04YARovEdNnu4SIuE97F2ppuX5X/IboLuqW+FEKqssHY
qhH1WBnxTRIta95eu+XCLxm+qlcIHD3NqJFZO5+Mv3VMqtWxDb9clq0V9GD9Tp8Rbzv4IqQs
MH4q8PF6Selm65R40odA1sCwtl3KWjJS5DxtptanYEwsGtKVU1Pc6sHivYblviIwKgYzay6y
knpcalLZkzpr5TqgpCyeud1Lp85kCAB2iiKTa8sH9xNidkQj9QoiOiRIxEJ3PkKWxehbsNS/
yky3ofJYRZmLYEfcftmh0dkNrecMePotocbfNG0cap2XOFhmqzdlkXgzMNTZBERgZxh7/oLb
wpwKDZFvOjo7ci3Pkg7B8hHEUHNSRPV15cQTNMEdy+b2DFhYLveP+E33fZUoLuGC/I01oGZL
nrW8gGNyXrB2WZMpotPGDXUc9wDjrBMgcdVI1cH8Ihqm3h7jLWfOxRqieqEZkfkTX3IITV+c
tKlzwSmC3ynCK1aDfE9tZIl3TgYJbOvEuFC9THNgjxMXMHVKRa2xejA7e9ocW1tZwuzdvcSA
XwYgkpGV9BErHyk5XnYwhRmouqmvI0a3dz82VviOduDwhpInwYr/9ZMdMWAIHiBA5w6cAOIu
sN8L9dARsVD1Wn5B/BdoAJ/iVSykjkHoGNZbU56jIY3ks8s41aOlK6crlJfcZfMJDphPyRr/
BvnKbrJfrTZHzhsoZ0FWLgn+VjEMgUPGScXmyZfjo88Unpf4DK5J2i8ftq+7s7OT878mHyjC
ZZue2U1cgBrXdvho0RarZHeoY6h11p8AeGxCQOsrWmMCnC+TaeFxbECldfd18/Z9h/nM/YEm
4l4K0EUguYJAgkplbTwBxPHGeGG8LWsHBQp2FteJwY0vkrowx0QbP7R8nVd2nwSAloQcmpA8
CDpnGgNLB6XN2G/yn0FU1MYmf8T6engjn9PKN6Wm7FPjs01nslnsyaEK5Ey2RqYefSLOodAJ
uwgfvoCSYaSoZTlzeyoA3rKchaQrt/jX1BW2NERVemjKzApzBeeiCvIbEK6RsAEt3Qkl7FcV
1gOQwBCZQIbAQ95RDZDoJuO0IVOiHbnKwokYqn6NIH8HLuFUt0Qs/QJEqHeJ4HwtA3KlSSbC
pXr9kLiUrcplTX8GdNRbeBqGWZnRGyqWwzhSGsdoWAA9FAeWAoOg6YIZDqR/evZlHJG8hxuK
m9f7ZbtICtDOdMy94aSsWU5H9b1csmZhMSgFkUKnPrUHs4GFjnlNmy16shjjh1YdhrLM6IoU
hQjbRVsqKEoU66KKel3dk+sR9Cty17+LB8WBGBA55X5t65vxbgfUjB5/LHxWZ9mFXtMuQZLP
kjg2g/UNs1CzeY4OZkqawgqOesnB1chzXsCxYqmxubcZFlWY0V4W6+MQnwTcqdOeArn2EaJR
CcNnyrD5ZtdSCQrYsW3KnBxcr77StD1KLHBI5/18D8/N/Vo1rRX7Q/7uJacLfP0wuwZB6cvk
cHpscP+BMENLlmbNlLAhKWGF9VSWoKLRx2QlBN0i+oPmzo6nZnM2EldtGBtEmJ9gRNp2u2g2
rcnGPsnqDVWA7l7fgw8P/9198Ig8y7fC4IOWcOXASy0+cN2sAvqCsx3kbykLWMcPZXfT0kft
anUa4oswPWbE5qlJbjhl1AXd7aqsLxyxbxDPgxaotDE2DP4CDda2eEjgkQegqI4dQFWkbj9i
uXdBVS2X1EIQJE3UcEnhVJhmoETAN/ZIu+rVcX/MdhmbkREf5zWLEjyFeGkGOoE+uT/d78Ev
JtRmae+ywqs0y6KuIvd3Nzf3HQCgrwjrLuqZ5U+nyGPeiMd5vBAfhRFIo/a6Io0yuoijfifV
wmHYCiSOHeraQqIp05dG2SNs4LllsuDamGC5+gowxs2/Gj5Lpugil70gX1YYe53qLPflLQHz
dtgApaI0Dli8b6s6FdLdKU32xKZprop3aUbGHtG1jGuipzWfofuU45s0QJWxNmIVsgCMoEWG
vzcKgF47A2bSnFiNEGs4KmNmK4qu4kgNNBv9wr5IBxPf2IFez6sAi8pMy0RmHA2+YQTR2rLS
HR99tgv2mM9HVkYoG/eZSnJkkZydHAYqPrOTADm4P6g41OOz02CTp5MgZhrEHIW7acfxo0lO
RopTCRsdkvNg8fOjd4uf248SnOLU9rZJjs9Do/L52MbwpsT11Z0FCkymI10BJJUaFmlEnC26
qYlbn0bQPl8mBe02ZVKEJlbjT+g+ndLgzzT4PPBh3orrMe91a+L066LkZ13tVieglFqJSIwD
CDqCmchQg6MEo067tUlM0SbLmr6q6onqEpT2QDqInui65lnGKUdpTTJnSUZ3A6PK0xqVpuDw
Dayg3dJ7mmLJSXHLHB1ODVC7rC+saEqIUFbnvpk4C3oU4Y6gnFDK7urStGha7gTyrfnm7u1l
u//tRwx0D2j83dWYRahRGjWlBSR1w0E0BqUb6DGImn1Pq+qhZHl58ZbEnZ3sBX518QIzLcpU
Iw5KXGcpo45pqNHyU5wnjXB9bmtuZuz0LUUaklLVKNnfEhA0bojBS0kFTg3dOjUzE/boipk6
+AK9skSi4iKRwYIxtaiQ6SJmWdY9Ista4dWQQhVuvDPD6wWGMRLEaCmUyT1pSt3tJhG5zt4h
yukIaz1BW+bldUmMikSItF54YVm1sEza+vrL9PD4bJR4GfNWxHxDqwPRJUVb5kDWv9QUWZrJ
q1S3XFUCI7lW9F8+fHr9tn36tN897n7v/to+bfcfQgVZ1PKVTPChok/r0rJYsKe9IN9fHyci
w+pYZ1lVMZjJmhhYjYIlYrIdGk8kBfPoPCE1QKK8S2gTTaiMioH5p4WGy7mx0cHJq3hB9lnh
YLWlZR0F3B818TULhRPuNwBL8e1FIBqE0SooxCWoN1lDuS4bOmER27Y5GVnLYmc9aHA0oJCs
uc4x8Svse5vvDiRtvWwUX3ajYhr14I4jP4+TYX+TlWUngp8d6pigniyXgXESNHEslVHyCFmp
ROvrk0NDREIwQiSP/fBps7/79HPz+/XTLwRu/v349/fNi7H1tO3S2YJEgx6lsePC1cVkhGGY
8y8fHm6fvmNcqI/41/fdf54+/r59vIVft9+ft08fX2//tYEi2+8ft0/7zT2e2x9vn59vXx53
Lx9fNw/bp7dfH18fb6ECyYw+fnv+1wd50F9sXp42DyL58uYJ/UCHA99ITnKAbGh7+7D97y1i
B2kgipAVCEeKbsVqmHnYYpVIg2fqsxQVJrKxFw0A8d3QhXfn5VPAeWU0Q9WBFNhEqB7h54M5
BPVElH5N+GIcRECDhLxkD4yRRoeHuA9w4EpbuqdrYFvCZmfq/iJmsx1aW8LyJI+qaxe6Njm9
BFWXLgQj4J+CPBSVhjeqkLxwjqS3x8vv5/3u4G73sjnYvRz82Dw8b15MPxBJ3qW8onahwrJs
zirutqHAUx+esJgE+qTNRcSrhenz6iD8IvYpZwB90tr0IhtgJKF/MOqOB3vCQp2/qCqf+sL0
s9Y1oP3eJwXVgs2JehXcL+Bm6bDpe8NoKDC3Ip+nk+mZlQZWIYplRgP9noh/iNkXN7aRXpbV
27eH7d1fwLkP7sQKvcccur8NFqXmpWFeVbE/+0kUEV+fRDH1CnHANowsVccNdcrphZkTH72s
V8n05GRyrj+Qve1/bJ7227vb/eb7QfIkvhK4xMF/tvsfB+z1dXe3Faj4dn/rfXZkJvPVk0PA
ogWobmx6CCLs9eTo8ITYdHPewKT62yu55B7TgG9fMOChK/0VMxHX8HH33fSG023PIr8/ZqI+
DWv9dRyZnnB9237ZrL4iZqhMqTtthayofq1tD2W9IZPrq5pRt0N6hS/CA4upzdqlPyXokdKP
3wJz2gSGTyZVcLiYk2lBdx++KdzLlSwkXfG295vXvd9YHR1NielCsD9Ya5LDzjJ2kUxnRPck
ZoSvQDvt5DDmqb+oyaaCo57HxwSMoOOwkJMM//VZfR5PTOOw3hALNqGA05NTCnwyIc6yBTvy
gTkBQ8fYWemfTVeVrFce0NvnH1Y4nH5P+5sHYF3rH9AghVzZkb0dxHCJ4U5qxDCMNx9hhBGT
MeLtS5AB508LQv3RjInvScW/QX5H9BcOwCopyIdFeiKOiWLtVYnj4LsA7x6fXzavr7bcrDss
3Bx8bmV6SinY2bG/TqTTjdsT4csQ7r7yrJKRLEGz2D0eFG+P3zYvMt6oK+GrZVE0vIsqSgyK
69lcpECgMQFOJHF0ZkKThGL6iPCAXzmqA2gIKk0h2BBrOkry1AgtDLr97PFajAz3tyetbXWY
QMMCXtHvN11iFHb/iDAphGBWztBBg8wx2vMMRhyawqKj3lKZ8v7D9tvLLWg3L7u3/faJOH4y
PlOMxFuHgHmXoyOR3Iw6ooS/ynsSGtWLTEYNVF8GwvHuUGwE4fowAVkSfcYmYyRj3xI8lIYP
HRHEkChwmggUyZwWpDuxZeTp0L/B0gs1slrOMkXTLGc2mbCgREmtzO3J8PBwcBC6iJozdFFd
IR5rkTTUPQGQftZ2Pe8No8Si5tHJJOqDrYzP0Z5dJdLFEp/UaOu/z483L3sMHAgy86tIl/i6
vX+63b+BWnv3Y3P3EzR0Mz8SOvQQtq4gvvny4YODTdZtzcxB8sp7FNIr8fjw/NQyCJZFzGrP
9EabD2XNsP8wsXXT0sT6TcYfjInu8owX2AfxpCfVzCILcglpWajsYEQK1s1AkYPzoaauAfCV
Fas74Tdv+swx50nXjIMMhMmFjGHVsWlAPCoivN+oy9xJ8mOSZEkRwKJnx7Llph9EVNaxzWIw
A3cCSmw+S0gDpLyhYplffRVx91muRjlgEHxBl4MjzgJNTm0KXzaGitplZ5c6st2CENAn2woc
NYIEmEAyu6bD8Fsk9BNCRcLqKxY4nhAP02l19tSS0yOHuUVk6lU+89WUyNBcXb1E3gt5LBuW
XlzmxuAMKNoNFKHS4dqGo+80nq22rHcjzxoH6vizGlCqZtO91YaS/aD9UwWYol/fINj93a3P
Tj2YiLVS+bScmROogMy86xxg7QK2kIfAvFJ+vbPoqwezp2j4oG5+wysSMQPElMSsb0iwJZgb
cPu1gt7DxMVsLSOIZ6Wl65hQvPI+C6CgRQM1i8w13GBccuA0K0wpUJup6dD2zksrqowEiWfm
FptZuCkXRUJD811tIfojEcA3ragVCIMuZkx4Ci+ENG70sI4WogFhcUbaVFzlrXjkpHydZ5hk
G9ZUab2iRhRKuiG/X5GlklXDqWKcs/NMzobR0KXJkKFF+xex6YvM9nfsp7ktc24zquyma5lR
I8aFA4nOaDGvuPXwhbiOi3lukZQ8xozYcJjX5uvismgN19h+tBBOviFG+rNfZ04NZ7/Mw6SZ
69HXAODLuR1KCe+0At435ewrm9Oihicp2NdQWv4S0OeX7dP+p0jl/P1x83rve6MIKUSmwHFO
ZASjNyh9cY9XRK3wRsaL87gzU8ZF0scd/QQyECyy3pz/OUhxueRJ++W4n1slwHo1GD4H8XXB
YNWMpcE0KbrAk0uQ0mfoddAldQ3kVtRpLAZ/QDaalSphqpqE4MD2Fovtw+av/fZRyX+vgvRO
wl/8aUhraFq87JaeFf0w17zCXFTYTfvBTIIuEhi2EaaCdDBuZKQDfFKZsxY4B9aOwSuuzQ/5
465aaVrUaos3397u7/FGjj+97l/eHlW6VT2LbM7Fc9bauC4zgP21oNS8vxz+mlBUMgQjXYMK
z9ig+xRGFB9UByOchQNRLtwss3mjxuIFjSDIMQoOvbDsmgK3rcLZSPDsi3lsvdBrmH+3K6Dd
DNqMmwBSnEoDifGScChKe7IJgmbBU8ooJ7ExX3k3yhKzLOoEVWqYomBp4Few3Jy3ZLpfJhuU
sKRY5uYq/KN15Y4/vnK2X0mYF+59HQavQ5YCmmJSuME9BKYqeVMGIis02XKmmrVLCoSXJ9fq
pwzxLS7EvYm9YDgcvq1DYtGxDfONFiVQ8RYGV2St1w+17Nvz4YPl9QP+PCh3z68fD7Ld3c+3
Z7mxF7dP91b0gYphmFh8uVuS984WHkMkLWGn2kg8PfBJy+H/GUGXxpqXLpLAbr6/IY8x52q4
0yfQ9sBisxdJUkltVqrReEk2LJ9/vD5vn/DiDHrx+Lbf/NrAfzb7u7///vufw7oQsU9ElSK7
q/dK5gp4wVIkHhkkmuE4/h9adFcwCDWgvMzJNzH9AWuuNsHC0TFjWTQgRoIgKVUsbxPI4f8p
t9P32/3tAe6jOzRI2GkrxYLuYtYyPCAxwBcPOGmMVilt4dGSnkoboT8Rv84e70H0El9Om2UY
JpkIuKwJZ1SUiJ3oeKIzPza/bu9FioOhi6bs1G5e9ziFuEwjzHRxe78x3HaX1v6VvnBDxjAL
bEu9EpasRce92BYSi3Ma9AiQzABYQFSuOil0mYpiDccU2k+wvMxObN4kZBexGdRPGP+EOatx
xlxgEEgOrRbRSTtHr0ENnjDuZ4raF8ka3yiRy70WS8FTGWSvJFY6zjY+srG8dqR9E8CtHT9P
wKXVjeiBrCtiReqVkZJ7qAz61TmNrx39UQAxyE0K4oIDrtGSIhLZOQjbwiJAPLa8JFJexNg5
2gpof0PK6xy4B72n5LeLsCMkHtoQeYvlYiVJ4FCSwRvHnURFG+QukSZWEmGYMb11FeWxiCZF
N2t+QRPsFB7hVMva7Egi5dzHSeZNNHqRMVhp3joVhlfu1gHkCurMGDrOVb57ru0URzIt58AQ
kajQq6qMlvhun2ae8myZcVSEynq0Ua1l/j/GZ+sywJcBAA==

--T4sUOijqQbZv57TR--
