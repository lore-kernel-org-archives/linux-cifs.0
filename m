Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4523274FCB
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 09:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758188668; cv=none; b=C/5ZjTWQmxt9xainc/C49gDFpjffDv4W6pR/XULZoHdHyeGTdaDV9J2jySQyTo+11zYuxi2MMtblOId0XHGfDs11YX/Q66Mf2cD7L3hwrImrGlXcND4KR6XVVGeuvPvtlTriewQ9CJse4NPRJEeEgSLskqYAlRe7NurTuXuJPoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758188668; c=relaxed/simple;
	bh=ecUwECiMZmq4a3VXQ4C20VmqMr9uJNcHAdn9TCOIneA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RDy+xgxWID95ZxHPBoIW5EWehWI3+/1o3pIe9IiPTKYA8gDO4SSJu8LtiKU8JLbCcdjhRv1CexPNI8mYVq4CPwAr6uB6bQRGk5cCaXDtH0Wq73h7vhIje9B7/HIu3pj/s5YwmWto/1bAQj1qlIwVrxBbdmKLpdXYTWfFWRM90Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RP//8TPl; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RP//8TPl"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45f29d2357aso4906615e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 02:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758188665; x=1758793465; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=52c6blvzODeo4kMzcwEtFvfzLTQJyYISjrM2lLbdddk=;
        b=RP//8TPl/4tiMxCho6B0NlsLgEtivrhTehQm5Z8ULRrau/phX4HqdNvXmx2afgxCTC
         bE9oRMmv3iI6q+xfji0KOZc5H0vhzlllP1t2V6xYnJubqXKr481r3hzm1BySpShqqmI1
         oDU/zrsW29j4LT6Z3JCzzha0FmADS2zhbPP9WLWkdyzvfTTnjMolvkK9Niq/1HOqIQnH
         IF5lzBepYQOXy9Ctir8+/LnBaEytcV871ZdiD95E/0VHjFYDvzxPfghOu4L3m6SYW5mT
         LLQ7ppDtCabLC47vSLv5IOp/KcF+jmnmeQ2WsYS1pAUsk6ahH70S9b/ewiALf+godc97
         wPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758188665; x=1758793465;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=52c6blvzODeo4kMzcwEtFvfzLTQJyYISjrM2lLbdddk=;
        b=NWpWhourcJjEquCq+2CfaZcIuV8nYlddA4UIn3/K4zKqjH8DHQzPPtosXlfb67kFSo
         xnq+xvRFB4j0S9zf9Zo/tbaSGXwJlUfVvIoiwleJSoeL0cwtvQm8ZFSMj/97wdiAs0n/
         QK1MvshOnGH577k0IhUDM33yin31uNsVOXc+pEvOi6NuOqT1uWXZ+l+x7GLZhdY5v3D6
         4mClobaa85UFI/JISoQ+yaFWyBoeQjTMSPN63OfBezrfJuMtZo/dpXtxYhlA4J0yjjNM
         2j3VoxeCEFzOV1F0ZgDYKnjrx5EvsoLug3SMBCKpkYo1C6eNUFUu1hENK6r6dbJ+H2Dy
         KYsQ==
X-Gm-Message-State: AOJu0YzPbvbHTjIMhXhqHmQ+eml1mXy4+HjiEhFaML0Ttuwh5LFC9iBy
	yHoel6KyEZInkUupvflhJziab6/YPRB6qmuPXAC/QTDWZje6ndw+lDo+0ar9jt42awI=
X-Gm-Gg: ASbGncuxsLsjCBi9tj+InzQ2kQQuIdjFYxchorofouTASQPjmFNnjlnwgFMlAb0zTqK
	U/BH4LajpQDjadsNlnYJhM/z2kXvrnXLeeb/82WMDpVXvixEL2LjWT8A/wcKyQUO8fVMywVfJzG
	g+PYLkqTYKmjruHfataBSP6FCE9ZGt6by/bS6/7quVUghdFxvmuQyMJFRXcg41nWvynrY7IVPeu
	zxVEeVcVC8r2UhY+Y7tiPLzxW+TKfhbgLki8fsPnUnvxpcyPRHA9Y3gqLOVAjIDGeLlm/0qWYSr
	PYiiH5aCNZscloiZsku4Omu58vO3sK6RNipu7Ju8XRShMn5aHydkHQD4eTatH4jWigZ0+K1j1wP
	hMxq4oyG6ecAUlvZyOfStD68ducbvbxnZenWFtbB80WtiWg==
X-Google-Smtp-Source: AGHT+IG9t0EBUDD5Qb2WxYtzRuDvJcv51bsr/PwbsV/aFkUmK7pE5swr2Hi9yTVBIx9INcWCWUxf/A==
X-Received: by 2002:a05:6000:430e:b0:3ee:13ab:cd35 with SMTP id ffacd0b85a97d-3ee13abd14bmr659771f8f.1.1758188664867;
        Thu, 18 Sep 2025 02:44:24 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-464f4f9f4e4sm36445845e9.13.2025.09.18.02.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 02:44:24 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:44:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] smb: client: batch SRV_COPYCHUNK entries to cut
 roundtrips
Message-ID: <aMvUdFU-ciu7Rgc6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Henrique Carvalho,

Commit 4e3acdf94c89 ("smb: client: batch SRV_COPYCHUNK entries to cut
roundtrips") from Sep 16, 2025 (linux-next), leads to the following
Smatch static checker warning:

	fs/smb/client/smb2ops.c:1937 smb2_copychunk_range()
	error: uninitialized symbol 'ret_data_len'.

fs/smb/client/smb2ops.c
    1844 static ssize_t
    1845 smb2_copychunk_range(const unsigned int xid,
    1846                      struct cifsFileInfo *src_file,
    1847                      struct cifsFileInfo *dst_file,
    1848                      u64 src_off,
    1849                      u64 len,
    1850                      u64 dst_off)
    1851 {
    1852         int rc = 0;
    1853         unsigned int ret_data_len;
    1854         struct copychunk_ioctl *cc_req = NULL;
    1855         struct copychunk_ioctl_rsp *cc_rsp = NULL;
    1856         struct cifs_tcon *tcon;
    1857         struct copychunk *chunk;
    1858         u32 chunks, chunk_count, chunk_bytes;
    1859         u32 copy_bytes, copy_bytes_left;
    1860         u32 chunks_written, bytes_written;
    1861         u64 total_bytes_left = len;
    1862         u64 src_off_prev, dst_off_prev;
    1863         u32 retries = 0;
    1864 
    1865         tcon = tlink_tcon(dst_file->tlink);
    1866 
    1867         trace_smb3_copychunk_enter(xid, src_file->fid.volatile_fid,
    1868                                    dst_file->fid.volatile_fid, tcon->tid,
    1869                                    tcon->ses->Suid, src_off, dst_off, len);
    1870 
    1871 retry:
    1872         chunk_count = calc_chunk_count(tcon, total_bytes_left);
    1873         if (!chunk_count) {
    1874                 rc = -EOPNOTSUPP;
    1875                 goto cchunk_out;
    1876         }
    1877 
    1878         cc_req = kzalloc(struct_size(cc_req, Chunks, chunk_count), GFP_KERNEL);
    1879         if (!cc_req) {
    1880                 rc = -ENOMEM;
    1881                 goto cchunk_out;
    1882         }
    1883 
    1884         /* Request a key from the server to identify the source of the copy */
    1885         rc = SMB2_request_res_key(xid,
    1886                                   tlink_tcon(src_file->tlink),
    1887                                   src_file->fid.persistent_fid,
    1888                                   src_file->fid.volatile_fid,
    1889                                   cc_req);
    1890 
    1891         /* Note: request_res_key sets res_key null only if rc != 0 */
    1892         if (rc)
    1893                 goto cchunk_out;
    1894 
    1895         while (total_bytes_left > 0) {
    1896 
    1897                 /* Store previous offsets to allow rewind */
    1898                 src_off_prev = src_off;
    1899                 dst_off_prev = dst_off;
    1900 
    1901                 trace_smb3_copychunk_iter(xid, src_file->fid.volatile_fid,
    1902                                           dst_file->fid.volatile_fid, tcon->tid,
    1903                                           tcon->ses->Suid, src_off, dst_off, len);
    1904 
    1905                 chunks = 0;
    1906                 copy_bytes = 0;
    1907                 copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
    1908                 while (copy_bytes_left > 0 && chunks < chunk_count) {
    1909                         chunk = &cc_req->Chunks[chunks++];
    1910 
    1911                         chunk->SourceOffset = cpu_to_le64(src_off);
    1912                         chunk->TargetOffset = cpu_to_le64(dst_off);
    1913 
    1914                         chunk_bytes = umin(copy_bytes_left, tcon->max_bytes_chunk);
    1915 
    1916                         chunk->Length = cpu_to_le32(chunk_bytes);
    1917                         chunk->Reserved = 0;
    1918 
    1919                         src_off += chunk_bytes;
    1920                         dst_off += chunk_bytes;
    1921 
    1922                         copy_bytes_left -= chunk_bytes;
    1923                         copy_bytes += chunk_bytes;
    1924                 }
    1925 
    1926                 cc_req->ChunkCount = cpu_to_le32(chunks);
    1927                 /* Buffer is zeroed, no need to set pcchunk->Reserved = 0 */
    1928 
    1929                 /* Request server copy to target from src identified by key */
    1930                 kfree(cc_rsp);
    1931                 cc_rsp = NULL;
    1932                 rc = SMB2_ioctl(xid, tcon, dst_file->fid.persistent_fid,
    1933                         dst_file->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
    1934                         (char *)cc_req, struct_size(cc_req, Chunks, chunks),
    1935                         CIFSMaxBufSize, (char **)&cc_rsp, &ret_data_len);
    1936 
--> 1937                 if (ret_data_len != sizeof(struct copychunk_ioctl_rsp)) {
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Using unintialized variables doesn't work because runtime checkers like
UBSan will complain as well as static checkers.

But the other issue is that this code treats -EINVAL as having a special
meaning.  -EINVAL is the most common error code.  All the places which
treat -EINVAL as having a special meaning end up buggy in the end.  Mostly
they start out buggy, but even the ones which aren't buggy from the start
end up buggy over time.

    1938                         cifs_tcon_dbg(VFS, "Copychunk invalid response: response size does not match expected size\n");
    1939                         rc = -EIO;
    1940                         goto cchunk_out;
    1941                 }
    1942 
    1943                 if (rc == 0) {
    1944                         bytes_written = le32_to_cpu(cc_rsp->TotalBytesWritten);
    1945                         if (bytes_written == 0) {
    1946                                 cifs_tcon_dbg(VFS, "Copychunk invalid response: no bytes copied\n");
    1947                                 rc = -EIO;
    1948                                 goto cchunk_out;
    1949                         }
    1950                         /* Check if server claimed to write more than we asked */
    1951                         if (bytes_written > copy_bytes) {
    1952                                 cifs_tcon_dbg(VFS, "Copychunk invalid response: unexpected value for TotalBytesWritten\n");
    1953                                 rc = -EIO;
    1954                                 goto cchunk_out;
    1955                         }
    1956 
    1957                         chunks_written = le32_to_cpu(cc_rsp->ChunksWritten);
    1958                         if (chunks_written > chunks) {
    1959                                 cifs_tcon_dbg(VFS, "Copychunk invalid response: Invalid num chunks written\n");
    1960                                 rc = -EIO;
    1961                                 goto cchunk_out;
    1962                         }
    1963 
    1964                         /* Partial write: rewind */
    1965                         if (bytes_written < copy_bytes) {
    1966                                 u32 delta = copy_bytes - bytes_written;
    1967 
    1968                                 src_off -= delta;
    1969                                 dst_off -= delta;
    1970                         }
    1971 
    1972                         total_bytes_left -= bytes_written;
    1973 
    1974                 } else if (rc == -EINVAL) {
    1975                         /*
    1976                          * Check if server is not asking us to reduce size.
    1977                          *
    1978                          * Note: As per MS-SMB2 2.2.32.1, the values returned
    1979                          * in cc_rsp are not strictly lower than what existed
    1980                          * before.
    1981                          *
    1982                          */
    1983                         if (le32_to_cpu(cc_rsp->ChunksWritten) < tcon->max_chunks) {
    1984                                 cifs_tcon_dbg(VFS, "Copychunk MaxChunks updated: %u -> %u\n",
    1985                                               tcon->max_chunks,
    1986                                               le32_to_cpu(cc_rsp->ChunksWritten));
    1987                                 tcon->max_chunks = le32_to_cpu(cc_rsp->ChunksWritten);
    1988                         }
    1989                         if (le32_to_cpu(cc_rsp->ChunkBytesWritten) < tcon->max_bytes_chunk) {
    1990                                 cifs_tcon_dbg(VFS, "Copychunk MaxBytesChunk updated: %u -> %u\n",
    1991                                               tcon->max_bytes_chunk,
    1992                                               le32_to_cpu(cc_rsp->ChunkBytesWritten));
    1993                                 tcon->max_bytes_chunk = le32_to_cpu(cc_rsp->ChunkBytesWritten);
    1994                         }
    1995                         if (le32_to_cpu(cc_rsp->TotalBytesWritten) < tcon->max_bytes_copy) {
    1996                                 cifs_tcon_dbg(VFS, "Copychunk MaxBytesCopy updated: %u -> %u\n",
    1997                                               tcon->max_bytes_copy,
    1998                                               le32_to_cpu(cc_rsp->TotalBytesWritten));
    1999                                 tcon->max_bytes_copy = le32_to_cpu(cc_rsp->TotalBytesWritten);
    2000                         }
    2001 
    2002                         trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
    2003                                                  dst_file->fid.volatile_fid, tcon->tid,
    2004                                                  tcon->ses->Suid, src_off, dst_off, len, rc);
    2005 
    2006                         /* Rewind */
    2007                         if (retries++ < 2) {
    2008                                 src_off = src_off_prev;
    2009                                 dst_off = dst_off_prev;
    2010                                 kfree(cc_req);
    2011                                 cc_req = NULL;
    2012                                 goto retry;
    2013                         } else
    2014                                 goto cchunk_out;
    2015                 } else { /* Unexpected */
    2016                         trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
    2017                                                  dst_file->fid.volatile_fid, tcon->tid,
    2018                                                  tcon->ses->Suid, src_off, dst_off, len, rc);
    2019                         goto cchunk_out;
    2020                 }
    2021         }
    2022 
    2023         trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid,
    2024                                   dst_file->fid.volatile_fid, tcon->tid,
    2025                                   tcon->ses->Suid, src_off, dst_off, len);
    2026 
    2027 cchunk_out:
    2028         kfree(cc_req);
    2029         kfree(cc_rsp);
    2030         if (rc)
    2031                 return rc;
    2032         else
    2033                 return len;
    2034 }

regards,
dan carpenter
