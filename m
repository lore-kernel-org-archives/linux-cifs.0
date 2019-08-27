Return-Path: <SRS0=wCsU=WX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111E4C3A5A3
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 22:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F1F217F5
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 22:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UxZ9oZ+f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfH0WeY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Aug 2019 18:34:24 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:42041 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfH0WeY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Aug 2019 18:34:24 -0400
Received: by mail-io1-f52.google.com with SMTP id e20so1817157iob.9
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MNPuKzL9kjhShbAJhFO7wRjquaJLv5Ij7cMEZrYSK/I=;
        b=UxZ9oZ+feCVMrQ04yE29y1V+7ey7kcTrzbNQTJWn5dOX06x1VFwwfjhSjbXJb2OSYy
         HMd5vME4DtK6LmRV20dvi1tKxyh0aYGiYzBYhKrwTIhGSs4sTS9HhQ1L6AVvMZkHL7la
         UDOvcSytea7bAhXuMLWG/+ZbHetGnixDKHSgReBfw76TyEfUYm+V5EmyzQ7qTfpUoJu6
         r7d8Heg3dTZ63LlnGnmYVwXNNT6YxtxNY0+uImCoMGgS8myhAtsy88EcvPpUOXkHcZ38
         TTF82uQ5x5NDpfTGWNGvDQOtppLfvZNPZIPn3ok2C3LDz8aL794JUZlzFWwfuXhOsnta
         Hmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MNPuKzL9kjhShbAJhFO7wRjquaJLv5Ij7cMEZrYSK/I=;
        b=lLGHpwST8TW7kI1cMWSoPzhZi1mHc1nk8PLi9w4NM7dR4fNo0HdGPzbl3nHiytm7BV
         eOyHUo4+4QdvQdzVIP9fx1cygXvm/ko4cDrzfZuPDwlQ+2qtCHd3XBRItY3F7sAtCyip
         XK1frZCBOxEmYGMWEuLyHhjVdGVWHB5cFGZe37mq/DdgwfceN8MT+KulrU1ovfZ0lBgZ
         JXEfFaqyQbmAuLiFm6h/20YHK2vEOE/6O0oBNqocNpy0vvD84r4HTFoReC4V+RFS6+z+
         nwk4AeG3GHDTWv3OsBAsAoC3Wk2P5ChmURUcZWhMfeKbaaIJrghfZKeL4YFqMriIf4+n
         ce3g==
X-Gm-Message-State: APjAAAVuwnaiwIq0MSU8ADt/1eY6SP1vIEviSVD0OFTWjEk2Ook4U1ex
        G1JJjtp6GBU+htKuOwaytcE90IgpdGlYNv1DYvYJCMbM
X-Google-Smtp-Source: APXvYqysd9ukXDw6LX7Fvmk0xtWeopy48gzyh4r646GFb/50CQkLMiemP+DW/Rm7CiNbZtF5a+v74JF0R8jJcOFZbl8=
X-Received: by 2002:a5e:c914:: with SMTP id z20mr752022iol.272.1566945262023;
 Tue, 27 Aug 2019 15:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190826233014.11539-1-lsahlber@redhat.com>
In-Reply-To: <20190826233014.11539-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 27 Aug 2019 17:34:10 -0500
Message-ID: <CAH2r5mvQ7YzkUjNJxC8sNCsbr-NXM9KC0tXYr2PgZ_zCR0Qu_A@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: replace various strncpy with memcpy and similar
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary="000000000000b9e927059120df76"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b9e927059120df76
Content-Type: text/plain; charset="UTF-8"

I updated the comments in Ronnie's patch  (attached) to add Aurelien's
reviewed-by and the reported-by Linus.  Since this is mostly ASCII
string handling for SMB1 mounts (and older SMB1 servers at that), it
is not as serious, but there were many places affected and could be a
problem for mounts to older servers.

Will run some additional tests on it before sending a PR upstream.

---------- Forwarded message ---------
From: Ronnie Sahlberg <lsahlber@redhat.com>
Date: Mon, Aug 26, 2019 at 6:30 PM
Subject: [PATCH] cifs: replace various strncpy with memcpy and similar
To: linux-cifs <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>


Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h |   1 +
 fs/cifs/cifssmb.c   | 197 +++++++++++++++++-----------------------------------
 fs/cifs/connect.c   |   7 +-
 fs/cifs/dir.c       |   5 +-
 fs/cifs/misc.c      |  22 ++++++
 fs/cifs/sess.c      |  26 ++++---
 6 files changed, 112 insertions(+), 146 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e23234207fc2..592a6cea2b79 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -579,6 +579,7 @@ extern void rqst_page_get_length(struct smb_rqst
*rqst, unsigned int page,
                                unsigned int *len, unsigned int *offset);

 void extract_unc_hostname(const char *unc, const char **h, size_t *len);
+int copy_path_name(char *dst, const char *src);

 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e2f95965065d..3907653e63c7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -942,10 +942,8 @@ CIFSPOSIXDelFile(const unsigned int xid, struct
cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else { /* BB add path length overrun check */
-               name_len = strnlen(fileName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, fileName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, fileName);
        }

        params = 6 + name_len;
@@ -1015,10 +1013,8 @@ CIFSSMBDelFile(const unsigned int xid, struct
cifs_tcon *tcon, const char *name,
                                              remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {                /* BB improve check for buffer overruns BB */
-               name_len = strnlen(name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->fileName, name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->fileName, name);
        }
        pSMB->SearchAttributes =
            cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM);
@@ -1062,10 +1058,8 @@ CIFSSMBRmDir(const unsigned int xid, struct
cifs_tcon *tcon, const char *name,
                                              remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {                /* BB improve check for buffer overruns BB */
-               name_len = strnlen(name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->DirName, name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->DirName, name);
        }

        pSMB->BufferFormat = 0x04;
@@ -1107,10 +1101,8 @@ CIFSSMBMkDir(const unsigned int xid, struct
cifs_tcon *tcon, const char *name,
                                              remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {                /* BB improve check for buffer overruns BB */
-               name_len = strnlen(name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->DirName, name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->DirName, name);
        }

        pSMB->BufferFormat = 0x04;
@@ -1157,10 +1149,8 @@ CIFSPOSIXCreate(const unsigned int xid, struct
cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, name);
        }

        params = 6 + name_len;
@@ -1324,11 +1314,9 @@ SMBLegacyOpen(const unsigned int xid, struct
cifs_tcon *tcon,
                                      fileName, PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {                /* BB improve check for buffer overruns BB */
+       } else {
                count = 0;      /* no pad */
-               name_len = strnlen(fileName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->fileName, fileName, name_len);
+               name_len = copy_path_name(pSMB->fileName, fileName);
        }
        if (*pOplock & REQ_OPLOCK)
                pSMB->OpenFlags = cpu_to_le16(REQ_OPLOCK);
@@ -1442,11 +1430,8 @@ CIFS_open(const unsigned int xid, struct
cifs_open_parms *oparms, int *oplock,
                /* BB improve check for buffer overruns BB */
                /* no pad */
                count = 0;
-               name_len = strnlen(path, PATH_MAX);
-               /* trailing null */
-               name_len++;
+               name_len = copy_path_name(req->fileName, path);
                req->NameLength = cpu_to_le16(name_len);
-               strncpy(req->fileName, path, name_len);
        }

        if (*oplock & REQ_OPLOCK)
@@ -2812,15 +2797,10 @@ CIFSSMBRename(const unsigned int xid, struct
cifs_tcon *tcon,
                                       remap);
                name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
                name_len2 *= 2; /* convert to bytes */
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(from_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->OldFileName, from_name, name_len);
-               name_len2 = strnlen(to_name, PATH_MAX);
-               name_len2++;    /* trailing null */
+       } else {
+               name_len = copy_path_name(pSMB->OldFileName, from_name);
+               name_len2 =
copy_path_name(pSMB->OldFileName+name_len+1, to_name);
                pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
-               strncpy(&pSMB->OldFileName[name_len + 1], to_name, name_len2);
-               name_len2++;    /* trailing null */
                name_len2++;    /* signature byte */
        }

@@ -2962,15 +2942,10 @@ CIFSSMBCopy(const unsigned int xid, struct
cifs_tcon *tcon,
                                       toName, PATH_MAX, nls_codepage, remap);
                name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
                name_len2 *= 2; /* convert to bytes */
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(fromName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->OldFileName, fromName, name_len);
-               name_len2 = strnlen(toName, PATH_MAX);
-               name_len2++;    /* trailing null */
+       } else {
+               name_len = copy_path_name(pSMB->OldFileName, fromName);
                pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
-               strncpy(&pSMB->OldFileName[name_len + 1], toName, name_len2);
-               name_len2++;    /* trailing null */
+               name_len2 =
copy_path_name(pSMB->OldFileName+name_len+1, toName);
                name_len2++;    /* signature byte */
        }

@@ -3021,10 +2996,8 @@ CIFSUnixCreateSymLink(const unsigned int xid,
struct cifs_tcon *tcon,
                name_len++;     /* trailing null */
                name_len *= 2;

-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(fromName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, fromName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, fromName);
        }
        params = 6 + name_len;
        pSMB->MaxSetupCount = 0;
@@ -3044,10 +3017,8 @@ CIFSUnixCreateSymLink(const unsigned int xid,
struct cifs_tcon *tcon,
                                        PATH_MAX, nls_codepage, remap);
                name_len_target++;      /* trailing null */
                name_len_target *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len_target = strnlen(toName, PATH_MAX);
-               name_len_target++;      /* trailing null */
-               strncpy(data_offset, toName, name_len_target);
+       } else {
+               name_len_target = copy_path_name(data_offset, toName);
        }

        pSMB->MaxParameterCount = cpu_to_le16(2);
@@ -3109,10 +3080,8 @@ CIFSUnixCreateHardLink(const unsigned int xid,
struct cifs_tcon *tcon,
                name_len++;     /* trailing null */
                name_len *= 2;

-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(toName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, toName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, toName);
        }
        params = 6 + name_len;
        pSMB->MaxSetupCount = 0;
@@ -3131,10 +3100,8 @@ CIFSUnixCreateHardLink(const unsigned int xid,
struct cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len_target++;      /* trailing null */
                name_len_target *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len_target = strnlen(fromName, PATH_MAX);
-               name_len_target++;      /* trailing null */
-               strncpy(data_offset, fromName, name_len_target);
+       } else {
+               name_len_target = copy_path_name(data_offset, fromName);
        }

        pSMB->MaxParameterCount = cpu_to_le16(2);
@@ -3213,15 +3180,10 @@ CIFSCreateHardLink(const unsigned int xid,
struct cifs_tcon *tcon,
                                       remap);
                name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
                name_len2 *= 2; /* convert to bytes */
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(from_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->OldFileName, from_name, name_len);
-               name_len2 = strnlen(to_name, PATH_MAX);
-               name_len2++;    /* trailing null */
+       } else {
+               name_len = copy_path_name(pSMB->OldFileName, from_name);
                pSMB->OldFileName[name_len] = 0x04;     /* 2nd buffer format */
-               strncpy(&pSMB->OldFileName[name_len + 1], to_name, name_len2);
-               name_len2++;    /* trailing null */
+               name_len2 =
copy_path_name(pSMB->OldFileName+name_len+1, to_name);
                name_len2++;    /* signature byte */
        }

@@ -3271,10 +3233,8 @@ CIFSSMBUnixQuerySymLink(const unsigned int xid,
struct cifs_tcon *tcon,
                                           remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(searchName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, searchName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, searchName);
        }

        params = 2 /* level */  + 4 /* rsrvd */  + name_len /* incl null */ ;
@@ -3691,10 +3651,8 @@ CIFSSMBGetPosixACL(const unsigned int xid,
struct cifs_tcon *tcon,
                name_len *= 2;
                pSMB->FileName[name_len] = 0;
                pSMB->FileName[name_len+1] = 0;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(searchName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, searchName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, searchName);
        }

        params = 2 /* level */  + 4 /* rsrvd */  + name_len /* incl null */ ;
@@ -3776,10 +3734,8 @@ CIFSSMBSetPosixACL(const unsigned int xid,
struct cifs_tcon *tcon,
                                           PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(fileName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, fileName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, fileName);
        }
        params = 6 + name_len;
        pSMB->MaxParameterCount = cpu_to_le16(2);
@@ -4184,9 +4140,7 @@ SMBQueryInformation(const unsigned int xid,
struct cifs_tcon *tcon,
                name_len++;     /* trailing null */
                name_len *= 2;
        } else {
-               name_len = strnlen(search_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, search_name, name_len);
+               name_len = copy_path_name(pSMB->FileName, search_name);
        }
        pSMB->BufferFormat = 0x04;
        name_len++; /* account for buffer type byte */
@@ -4321,10 +4275,8 @@ CIFSSMBQPathInfo(const unsigned int xid, struct
cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(search_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, search_name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, search_name);
        }

        params = 2 /* level */ + 4 /* reserved */ + name_len /* includes NUL */;
@@ -4490,10 +4442,8 @@ CIFSSMBUnixQPathInfo(const unsigned int xid,
struct cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(searchName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, searchName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, searchName);
        }

        params = 2 /* level */ + 4 /* reserved */ + name_len /* includes NUL */;
@@ -4593,17 +4543,16 @@ CIFSFindFirst(const unsigned int xid, struct
cifs_tcon *tcon,
                        pSMB->FileName[name_len+1] = 0;
                        name_len += 2;
                }
-       } else {        /* BB add check for overrun of SMB buf BB */
-               name_len = strnlen(searchName, PATH_MAX);
-/* BB fix here and in unicode clause above ie
-               if (name_len > buffersize-header)
-                       free buffer exit; BB */
-               strncpy(pSMB->FileName, searchName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, searchName);
                if (msearch) {
-                       pSMB->FileName[name_len] = CIFS_DIR_SEP(cifs_sb);
-                       pSMB->FileName[name_len+1] = '*';
-                       pSMB->FileName[name_len+2] = 0;
-                       name_len += 3;
+                       if (WARN_ON_ONCE(name_len > PATH_MAX-2))
+                               name_len = PATH_MAX-2;
+                       /* overwrite nul byte */
+                       pSMB->FileName[name_len-1] = CIFS_DIR_SEP(cifs_sb);
+                       pSMB->FileName[name_len] = '*';
+                       pSMB->FileName[name_len+1] = 0;
+                       name_len += 2;
                }
        }

@@ -4898,10 +4847,8 @@ CIFSGetSrvInodeNumber(const unsigned int xid,
struct cifs_tcon *tcon,
                                           remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(search_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, search_name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, search_name);
        }

        params = 2 /* level */  + 4 /* rsrvd */  + name_len /* incl null */ ;
@@ -5008,9 +4955,7 @@ CIFSGetDFSRefer(const unsigned int xid, struct
cifs_ses *ses,
                name_len++;     /* trailing null */
                name_len *= 2;
        } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(search_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->RequestFileName, search_name, name_len);
+               name_len = copy_path_name(pSMB->RequestFileName, search_name);
        }

        if (ses->server->sign)
@@ -5663,10 +5608,8 @@ CIFSSMBSetEOF(const unsigned int xid, struct
cifs_tcon *tcon,
                                       PATH_MAX, cifs_sb->local_nls, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(file_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, file_name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, file_name);
        }
        params = 6 + name_len;
        data_count = sizeof(struct file_end_of_file_info);
@@ -5959,10 +5902,8 @@ CIFSSMBSetPathInfo(const unsigned int xid,
struct cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(fileName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, fileName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, fileName);
        }

        params = 6 + name_len;
@@ -6040,10 +5981,8 @@ CIFSSMBSetAttrLegacy(unsigned int xid, struct
cifs_tcon *tcon, char *fileName,
                                       PATH_MAX, nls_codepage);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(fileName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->fileName, fileName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->fileName, fileName);
        }
        pSMB->attr = cpu_to_le16(dos_attrs);
        pSMB->BufferFormat = 0x04;
@@ -6203,10 +6142,8 @@ CIFSSMBUnixSetPathInfo(const unsigned int xid,
struct cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(file_name, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, file_name, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, file_name);
        }

        params = 6 + name_len;
@@ -6298,10 +6235,8 @@ CIFSSMBQAllEAs(const unsigned int xid, struct
cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                list_len++;     /* trailing null */
                list_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               list_len = strnlen(searchName, PATH_MAX);
-               list_len++;     /* trailing null */
-               strncpy(pSMB->FileName, searchName, list_len);
+       } else {
+               list_len = copy_path_name(pSMB->FileName, searchName);
        }

        params = 2 /* level */ + 4 /* reserved */ + list_len /* includes NUL */;
@@ -6480,10 +6415,8 @@ CIFSSMBSetEA(const unsigned int xid, struct
cifs_tcon *tcon,
                                       PATH_MAX, nls_codepage, remap);
                name_len++;     /* trailing null */
                name_len *= 2;
-       } else {        /* BB improve the check for buffer overruns BB */
-               name_len = strnlen(fileName, PATH_MAX);
-               name_len++;     /* trailing null */
-               strncpy(pSMB->FileName, fileName, name_len);
+       } else {
+               name_len = copy_path_name(pSMB->FileName, fileName);
        }

        params = 6 + name_len;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6f5c3ef327bd..1ed449f4a8ec 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4231,16 +4231,19 @@ build_unc_path_to_root(const struct smb_vol *vol,
                strlen(vol->prepath) + 1 : 0;
        unsigned int unc_len = strnlen(vol->UNC, MAX_TREE_SIZE + 1);

+       if (unc_len > MAX_TREE_SIZE)
+               return ERR_PTR(-EINVAL);
+
        full_path = kmalloc(unc_len + pplen + 1, GFP_KERNEL);
        if (full_path == NULL)
                return ERR_PTR(-ENOMEM);

-       strncpy(full_path, vol->UNC, unc_len);
+       memcpy(full_path, vol->UNC, unc_len);
        pos = full_path + unc_len;

        if (pplen) {
                *pos = CIFS_DIR_SEP(cifs_sb);
-               strncpy(pos + 1, vol->prepath, pplen);
+               memcpy(pos + 1, vol->prepath, pplen);
                pos += pplen;
        }

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f26a48dd2e39..be424e81e3ad 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -69,11 +69,10 @@ cifs_build_path_to_root(struct smb_vol *vol,
struct cifs_sb_info *cifs_sb,
                return full_path;

        if (dfsplen)
-               strncpy(full_path, tcon->treeName, dfsplen);
+               memcpy(full_path, tcon->treeName, dfsplen);
        full_path[dfsplen] = CIFS_DIR_SEP(cifs_sb);
-       strncpy(full_path + dfsplen + 1, vol->prepath, pplen);
+       memcpy(full_path + dfsplen + 1, vol->prepath, pplen);
        convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
-       full_path[dfsplen + pplen] = 0; /* add trailing null */
        return full_path;
 }

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index f383877a6511..5ad83bdb9bea 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1011,3 +1011,25 @@ void extract_unc_hostname(const char *unc,
const char **h, size_t *len)
        *h = unc;
        *len = end - unc;
 }
+
+/**
+ * copy_path_name - copy src path to dst, possibly truncating
+ *
+ * returns number of bytes written (including trailing nul)
+ */
+int copy_path_name(char *dst, const char *src)
+{
+       int name_len;
+
+       /*
+        * PATH_MAX includes nul, so if strlen(src) >= PATH_MAX it
+        * will truncate and strlen(dst) will be PATH_MAX-1
+        */
+       name_len = strscpy(dst, src, PATH_MAX);
+       if (WARN_ON_ONCE(name_len < 0))
+               name_len = PATH_MAX-1;
+
+       /* we count the trailing nul */
+       name_len++;
+       return name_len;
+}
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index dcd49ad60c83..4c764ff7edd2 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -159,13 +159,16 @@ static void ascii_ssetup_strings(char
**pbcc_area, struct cifs_ses *ses,
                                 const struct nls_table *nls_cp)
 {
        char *bcc_ptr = *pbcc_area;
+       int len;

        /* copy user */
        /* BB what about null user mounts - check that we do this BB */
        /* copy user */
        if (ses->user_name != NULL) {
-               strncpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
-               bcc_ptr += strnlen(ses->user_name, CIFS_MAX_USERNAME_LEN);
+               len = strscpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
+               if (WARN_ON_ONCE(len < 0))
+                       len = CIFS_MAX_USERNAME_LEN - 1;
+               bcc_ptr += len;
        }
        /* else null user mount */
        *bcc_ptr = 0;
@@ -173,8 +176,10 @@ static void ascii_ssetup_strings(char
**pbcc_area, struct cifs_ses *ses,

        /* copy domain */
        if (ses->domainName != NULL) {
-               strncpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
-               bcc_ptr += strnlen(ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
+               len = strscpy(bcc_ptr, ses->domainName,
CIFS_MAX_DOMAINNAME_LEN);
+               if (WARN_ON_ONCE(len < 0))
+                       len = CIFS_MAX_DOMAINNAME_LEN - 1;
+               bcc_ptr += len;
        } /* else we will send a null domain name
             so the server will default to its own domain */
        *bcc_ptr = 0;
@@ -242,9 +247,10 @@ static void decode_ascii_ssetup(char **pbcc_area,
__u16 bleft,

        kfree(ses->serverOS);

-       ses->serverOS = kzalloc(len + 1, GFP_KERNEL);
+       ses->serverOS = kmalloc(len + 1, GFP_KERNEL);
        if (ses->serverOS) {
-               strncpy(ses->serverOS, bcc_ptr, len);
+               memcpy(ses->serverOS, bcc_ptr, len);
+               ses->serverOS[len] = 0;
                if (strncmp(ses->serverOS, "OS/2", 4) == 0)
                        cifs_dbg(FYI, "OS/2 server\n");
        }
@@ -258,9 +264,11 @@ static void decode_ascii_ssetup(char **pbcc_area,
__u16 bleft,

        kfree(ses->serverNOS);

-       ses->serverNOS = kzalloc(len + 1, GFP_KERNEL);
-       if (ses->serverNOS)
-               strncpy(ses->serverNOS, bcc_ptr, len);
+       ses->serverNOS = kmalloc(len + 1, GFP_KERNEL);
+       if (ses->serverNOS) {
+               memcpy(ses->serverNOS, bcc_ptr, len);
+               ses->serverNOS[len] = 0;
+       }

        bcc_ptr += len + 1;
        bleft -= len + 1;
--
2.13.6



--
Thanks,

Steve

--000000000000b9e927059120df76
Content-Type: application/x-patch; 
	name="0001-cifs-replace-various-strncpy-with-strscpy-and-simila.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-replace-various-strncpy-with-strscpy-and-simila.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jzueki7l0>
X-Attachment-Id: f_jzueki7l0

RnJvbSA4YmE5Mjg0Mjk0OGMxNjllNDZmMmE5NmE4YjVkNTVkYTkwMmY2OTcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFR1ZSwgMjcgQXVnIDIwMTkgMDk6MzA6MTQgKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiByZXBsYWNlIHZhcmlvdXMgc3RybmNweSB3aXRoIHN0cnNjcHkgYW5kIHNpbWlsYXIKClVz
aW5nIHN0cnNjcHkgaXMgY2xlYW5lciwgYW5kIGF2b2lkcyBzb21lIHByb2JsZW1zIHdpdGgKaGFu
ZGxpbmcgbWF4aW11bSBsZW5ndGggc3RyaW5ncy4gIExpbnVzIG5vdGljZWQgdGhlCm9yaWdpbmFs
IHByb2JsZW0gYW5kIEF1cmVsaWVuIHBvaW50ZWQgb3V0IHNvbWUgYWRkaXRpb25hbApwcm9ibGVt
cy4gRm9ydHVuYXRlbHkgbW9zdCBvZiB0aGlzIGlzIFNNQjEgY29kZSAoYW5kCmluIHBhcnRpY3Vs
YXIgdGhlIEFTQ0lJIHN0cmluZyBoYW5kbGluZyBvbGRlciwgd2hpY2gKaXMgbGVzcyBjb21tb24p
LgoKUmVwb3J0ZWQtYnk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9u
Lm9yZz4KUmV2aWV3ZWQtYnk6IEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3VzZS5jb20+ClNpZ25l
ZC1vZmYtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9m
Zi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMv
Y2lmc3Byb3RvLmggfCAgIDEgKwogZnMvY2lmcy9jaWZzc21iLmMgICB8IDE5NyArKysrKysrKysr
KysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZnMvY2lmcy9jb25uZWN0LmMgICB8
ICAgNyArLQogZnMvY2lmcy9kaXIuYyAgICAgICB8ICAgNSArLQogZnMvY2lmcy9taXNjLmMgICAg
ICB8ICAyMiArKysrKwogZnMvY2lmcy9zZXNzLmMgICAgICB8ICAyNiArKysrLS0KIDYgZmlsZXMg
Y2hhbmdlZCwgMTEyIGluc2VydGlvbnMoKyksIDE0NiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2NpZnNwcm90by5oIGIvZnMvY2lmcy9jaWZzcHJvdG8uaAppbmRleCBlMjMyMzQy
MDdmYzIuLjU5MmE2Y2VhMmI3OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAorKysg
Yi9mcy9jaWZzL2NpZnNwcm90by5oCkBAIC01NzksNiArNTc5LDcgQEAgZXh0ZXJuIHZvaWQgcnFz
dF9wYWdlX2dldF9sZW5ndGgoc3RydWN0IHNtYl9ycXN0ICpycXN0LCB1bnNpZ25lZCBpbnQgcGFn
ZSwKIAkJCQl1bnNpZ25lZCBpbnQgKmxlbiwgdW5zaWduZWQgaW50ICpvZmZzZXQpOwogCiB2b2lk
IGV4dHJhY3RfdW5jX2hvc3RuYW1lKGNvbnN0IGNoYXIgKnVuYywgY29uc3QgY2hhciAqKmgsIHNp
emVfdCAqbGVuKTsKK2ludCBjb3B5X3BhdGhfbmFtZShjaGFyICpkc3QsIGNvbnN0IGNoYXIgKnNy
Yyk7CiAKICNpZmRlZiBDT05GSUdfQ0lGU19ERlNfVVBDQUxMCiBzdGF0aWMgaW5saW5lIGludCBn
ZXRfZGZzX3BhdGgoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMs
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2NpZnMvY2lmc3NtYi5jCmluZGV4
IGUyZjk1OTY1MDY1ZC4uMzkwNzY1M2U2M2M3IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNzbWIu
YworKysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtOTQyLDEwICs5NDIsOCBAQCBDSUZTUE9TSVhE
ZWxGaWxlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CQkJICAgICAgIFBBVEhfTUFYLCBubHNfY29kZXBhZ2UsIHJlbWFwKTsKIAkJbmFtZV9sZW4rKzsJ
LyogdHJhaWxpbmcgbnVsbCAqLwogCQluYW1lX2xlbiAqPSAyOwotCX0gZWxzZSB7IC8qIEJCIGFk
ZCBwYXRoIGxlbmd0aCBvdmVycnVuIGNoZWNrICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihmaWxl
TmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisrOwkvKiB0cmFpbGluZyBudWxsICovCi0JCXN0
cm5jcHkocFNNQi0+RmlsZU5hbWUsIGZpbGVOYW1lLCBuYW1lX2xlbik7CisJfSBlbHNlIHsKKwkJ
bmFtZV9sZW4gPSBjb3B5X3BhdGhfbmFtZShwU01CLT5GaWxlTmFtZSwgZmlsZU5hbWUpOwogCX0K
IAogCXBhcmFtcyA9IDYgKyBuYW1lX2xlbjsKQEAgLTEwMTUsMTAgKzEwMTMsOCBAQCBDSUZTU01C
RGVsRmlsZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBj
b25zdCBjaGFyICpuYW1lLAogCQkJCQkgICAgICByZW1hcCk7CiAJCW5hbWVfbGVuKys7CS8qIHRy
YWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsKLQl9IGVsc2UgewkJLyogQkIgaW1wcm92
ZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0gc3Rybmxlbihu
YW1lLCBQQVRIX01BWCk7Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3Ry
bmNweShwU01CLT5maWxlTmFtZSwgbmFtZSwgbmFtZV9sZW4pOworCX0gZWxzZSB7CisJCW5hbWVf
bGVuID0gY29weV9wYXRoX25hbWUocFNNQi0+ZmlsZU5hbWUsIG5hbWUpOwogCX0KIAlwU01CLT5T
ZWFyY2hBdHRyaWJ1dGVzID0KIAkgICAgY3B1X3RvX2xlMTYoQVRUUl9SRUFET05MWSB8IEFUVFJf
SElEREVOIHwgQVRUUl9TWVNURU0pOwpAQCAtMTA2MiwxMCArMTA1OCw4IEBAIENJRlNTTUJSbURp
cihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjb25zdCBj
aGFyICpuYW1lLAogCQkJCQkgICAgICByZW1hcCk7CiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5n
IG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsKLQl9IGVsc2UgewkJLyogQkIgaW1wcm92ZSBjaGVj
ayBmb3IgYnVmZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihuYW1lLCBQ
QVRIX01BWCk7Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShw
U01CLT5EaXJOYW1lLCBuYW1lLCBuYW1lX2xlbik7CisJfSBlbHNlIHsKKwkJbmFtZV9sZW4gPSBj
b3B5X3BhdGhfbmFtZShwU01CLT5EaXJOYW1lLCBuYW1lKTsKIAl9CiAKIAlwU01CLT5CdWZmZXJG
b3JtYXQgPSAweDA0OwpAQCAtMTEwNywxMCArMTEwMSw4IEBAIENJRlNTTUJNa0Rpcihjb25zdCB1
bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjb25zdCBjaGFyICpuYW1l
LAogCQkJCQkgICAgICByZW1hcCk7CiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8K
IAkJbmFtZV9sZW4gKj0gMjsKLQl9IGVsc2UgewkJLyogQkIgaW1wcm92ZSBjaGVjayBmb3IgYnVm
ZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihuYW1lLCBQQVRIX01BWCk7
Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5EaXJO
YW1lLCBuYW1lLCBuYW1lX2xlbik7CisJfSBlbHNlIHsKKwkJbmFtZV9sZW4gPSBjb3B5X3BhdGhf
bmFtZShwU01CLT5EaXJOYW1lLCBuYW1lKTsKIAl9CiAKIAlwU01CLT5CdWZmZXJGb3JtYXQgPSAw
eDA0OwpAQCAtMTE1NywxMCArMTE0OSw4IEBAIENJRlNQT1NJWENyZWF0ZShjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCSAgICAgICBQQVRIX01BWCwg
bmxzX2NvZGVwYWdlLCByZW1hcCk7CiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8K
IAkJbmFtZV9sZW4gKj0gMjsKLQl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3Ig
YnVmZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihuYW1lLCBQQVRIX01B
WCk7Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5G
aWxlTmFtZSwgbmFtZSwgbmFtZV9sZW4pOworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29weV9w
YXRoX25hbWUocFNNQi0+RmlsZU5hbWUsIG5hbWUpOwogCX0KIAogCXBhcmFtcyA9IDYgKyBuYW1l
X2xlbjsKQEAgLTEzMjQsMTEgKzEzMTQsOSBAQCBTTUJMZWdhY3lPcGVuKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJICAgICAgZmlsZU5hbWUsIFBB
VEhfTUFYLCBubHNfY29kZXBhZ2UsIHJlbWFwKTsKIAkJbmFtZV9sZW4rKzsgICAgIC8qIHRyYWls
aW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsKLQl9IGVsc2UgeyAgICAgICAgICAgICAgICAv
KiBCQiBpbXByb3ZlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8KKwl9IGVsc2Ugewog
CQljb3VudCA9IDA7ICAgICAgLyogbm8gcGFkICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihmaWxl
TmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisrOyAgICAgLyogdHJhaWxpbmcgbnVsbCAqLwot
CQlzdHJuY3B5KHBTTUItPmZpbGVOYW1lLCBmaWxlTmFtZSwgbmFtZV9sZW4pOworCQluYW1lX2xl
biA9IGNvcHlfcGF0aF9uYW1lKHBTTUItPmZpbGVOYW1lLCBmaWxlTmFtZSk7CiAJfQogCWlmICgq
cE9wbG9jayAmIFJFUV9PUExPQ0spCiAJCXBTTUItPk9wZW5GbGFncyA9IGNwdV90b19sZTE2KFJF
UV9PUExPQ0spOwpAQCAtMTQ0MiwxMSArMTQzMCw4IEBAIENJRlNfb3Blbihjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19vcGVuX3Bhcm1zICpvcGFybXMsIGludCAqb3Bsb2NrLAog
CQkvKiBCQiBpbXByb3ZlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8KIAkJLyogbm8g
cGFkICovCiAJCWNvdW50ID0gMDsKLQkJbmFtZV9sZW4gPSBzdHJubGVuKHBhdGgsIFBBVEhfTUFY
KTsKLQkJLyogdHJhaWxpbmcgbnVsbCAqLwotCQluYW1lX2xlbisrOworCQluYW1lX2xlbiA9IGNv
cHlfcGF0aF9uYW1lKHJlcS0+ZmlsZU5hbWUsIHBhdGgpOwogCQlyZXEtPk5hbWVMZW5ndGggPSBj
cHVfdG9fbGUxNihuYW1lX2xlbik7Ci0JCXN0cm5jcHkocmVxLT5maWxlTmFtZSwgcGF0aCwgbmFt
ZV9sZW4pOwogCX0KIAogCWlmICgqb3Bsb2NrICYgUkVRX09QTE9DSykKQEAgLTI4MTIsMTUgKzI3
OTcsMTAgQEAgQ0lGU1NNQlJlbmFtZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCQkJCSAgICAgICByZW1hcCk7CiAJCW5hbWVfbGVuMiArPSAxIC8qIHRy
YWlsaW5nIG51bGwgKi8gICsgMSAvKiBTaWduYXR1cmUgd29yZCAqLyA7CiAJCW5hbWVfbGVuMiAq
PSAyOwkvKiBjb252ZXJ0IHRvIGJ5dGVzICovCi0JfSBlbHNlIHsJLyogQkIgaW1wcm92ZSB0aGUg
Y2hlY2sgZm9yIGJ1ZmZlciBvdmVycnVucyBCQiAqLwotCQluYW1lX2xlbiA9IHN0cm5sZW4oZnJv
bV9uYW1lLCBQQVRIX01BWCk7Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJ
c3RybmNweShwU01CLT5PbGRGaWxlTmFtZSwgZnJvbV9uYW1lLCBuYW1lX2xlbik7Ci0JCW5hbWVf
bGVuMiA9IHN0cm5sZW4odG9fbmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbjIrKzsJLyogdHJh
aWxpbmcgbnVsbCAqLworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29weV9wYXRoX25hbWUocFNN
Qi0+T2xkRmlsZU5hbWUsIGZyb21fbmFtZSk7CisJCW5hbWVfbGVuMiA9IGNvcHlfcGF0aF9uYW1l
KHBTTUItPk9sZEZpbGVOYW1lK25hbWVfbGVuKzEsIHRvX25hbWUpOwogCQlwU01CLT5PbGRGaWxl
TmFtZVtuYW1lX2xlbl0gPSAweDA0OyAgLyogMm5kIGJ1ZmZlciBmb3JtYXQgKi8KLQkJc3RybmNw
eSgmcFNNQi0+T2xkRmlsZU5hbWVbbmFtZV9sZW4gKyAxXSwgdG9fbmFtZSwgbmFtZV9sZW4yKTsK
LQkJbmFtZV9sZW4yKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4yKys7CS8qIHNp
Z25hdHVyZSBieXRlICovCiAJfQogCkBAIC0yOTYyLDE1ICsyOTQyLDEwIEBAIENJRlNTTUJDb3B5
KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJICAg
ICAgIHRvTmFtZSwgUEFUSF9NQVgsIG5sc19jb2RlcGFnZSwgcmVtYXApOwogCQluYW1lX2xlbjIg
Kz0gMSAvKiB0cmFpbGluZyBudWxsICovICArIDEgLyogU2lnbmF0dXJlIHdvcmQgKi8gOwogCQlu
YW1lX2xlbjIgKj0gMjsgLyogY29udmVydCB0byBieXRlcyAqLwotCX0gZWxzZSB7IAkvKiBCQiBp
bXByb3ZlIHRoZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0g
c3Rybmxlbihmcm9tTmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisrOyAgICAgLyogdHJhaWxp
bmcgbnVsbCAqLwotCQlzdHJuY3B5KHBTTUItPk9sZEZpbGVOYW1lLCBmcm9tTmFtZSwgbmFtZV9s
ZW4pOwotCQluYW1lX2xlbjIgPSBzdHJubGVuKHRvTmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xl
bjIrKzsgICAgLyogdHJhaWxpbmcgbnVsbCAqLworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29w
eV9wYXRoX25hbWUocFNNQi0+T2xkRmlsZU5hbWUsIGZyb21OYW1lKTsKIAkJcFNNQi0+T2xkRmls
ZU5hbWVbbmFtZV9sZW5dID0gMHgwNDsgIC8qIDJuZCBidWZmZXIgZm9ybWF0ICovCi0JCXN0cm5j
cHkoJnBTTUItPk9sZEZpbGVOYW1lW25hbWVfbGVuICsgMV0sIHRvTmFtZSwgbmFtZV9sZW4yKTsK
LQkJbmFtZV9sZW4yKys7ICAgIC8qIHRyYWlsaW5nIG51bGwgKi8KKwkJbmFtZV9sZW4yID0gY29w
eV9wYXRoX25hbWUocFNNQi0+T2xkRmlsZU5hbWUrbmFtZV9sZW4rMSwgdG9OYW1lKTsKIAkJbmFt
ZV9sZW4yKys7ICAgIC8qIHNpZ25hdHVyZSBieXRlICovCiAJfQogCkBAIC0zMDIxLDEwICsyOTk2
LDggQEAgQ0lGU1VuaXhDcmVhdGVTeW1MaW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJ
bmFtZV9sZW4gKj0gMjsKIAotCX0gZWxzZSB7CS8qIEJCIGltcHJvdmUgdGhlIGNoZWNrIGZvciBi
dWZmZXIgb3ZlcnJ1bnMgQkIgKi8KLQkJbmFtZV9sZW4gPSBzdHJubGVuKGZyb21OYW1lLCBQQVRI
X01BWCk7Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01C
LT5GaWxlTmFtZSwgZnJvbU5hbWUsIG5hbWVfbGVuKTsKKwl9IGVsc2UgeworCQluYW1lX2xlbiA9
IGNvcHlfcGF0aF9uYW1lKHBTTUItPkZpbGVOYW1lLCBmcm9tTmFtZSk7CiAJfQogCXBhcmFtcyA9
IDYgKyBuYW1lX2xlbjsKIAlwU01CLT5NYXhTZXR1cENvdW50ID0gMDsKQEAgLTMwNDQsMTAgKzMw
MTcsOCBAQCBDSUZTVW5peENyZWF0ZVN5bUxpbmsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJUEFUSF9NQVgsIG5sc19jb2RlcGFnZSwgcmVtYXAp
OwogCQluYW1lX2xlbl90YXJnZXQrKzsJLyogdHJhaWxpbmcgbnVsbCAqLwogCQluYW1lX2xlbl90
YXJnZXQgKj0gMjsKLQl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3IgYnVmZmVy
IG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuX3RhcmdldCA9IHN0cm5sZW4odG9OYW1lLCBQQVRI
X01BWCk7Ci0JCW5hbWVfbGVuX3RhcmdldCsrOwkvKiB0cmFpbGluZyBudWxsICovCi0JCXN0cm5j
cHkoZGF0YV9vZmZzZXQsIHRvTmFtZSwgbmFtZV9sZW5fdGFyZ2V0KTsKKwl9IGVsc2UgeworCQlu
YW1lX2xlbl90YXJnZXQgPSBjb3B5X3BhdGhfbmFtZShkYXRhX29mZnNldCwgdG9OYW1lKTsKIAl9
CiAKIAlwU01CLT5NYXhQYXJhbWV0ZXJDb3VudCA9IGNwdV90b19sZTE2KDIpOwpAQCAtMzEwOSwx
MCArMzA4MCw4IEBAIENJRlNVbml4Q3JlYXRlSGFyZExpbmsoY29uc3QgdW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJbmFtZV9sZW4rKzsJLyogdHJhaWxpbmcgbnVs
bCAqLwogCQluYW1lX2xlbiAqPSAyOwogCi0JfSBlbHNlIHsJLyogQkIgaW1wcm92ZSB0aGUgY2hl
Y2sgZm9yIGJ1ZmZlciBvdmVycnVucyBCQiAqLwotCQluYW1lX2xlbiA9IHN0cm5sZW4odG9OYW1l
LCBQQVRIX01BWCk7Ci0JCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNw
eShwU01CLT5GaWxlTmFtZSwgdG9OYW1lLCBuYW1lX2xlbik7CisJfSBlbHNlIHsKKwkJbmFtZV9s
ZW4gPSBjb3B5X3BhdGhfbmFtZShwU01CLT5GaWxlTmFtZSwgdG9OYW1lKTsKIAl9CiAJcGFyYW1z
ID0gNiArIG5hbWVfbGVuOwogCXBTTUItPk1heFNldHVwQ291bnQgPSAwOwpAQCAtMzEzMSwxMCAr
MzEwMCw4IEBAIENJRlNVbml4Q3JlYXRlSGFyZExpbmsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkgICAgICAgUEFUSF9NQVgsIG5sc19jb2RlcGFn
ZSwgcmVtYXApOwogCQluYW1lX2xlbl90YXJnZXQrKzsJLyogdHJhaWxpbmcgbnVsbCAqLwogCQlu
YW1lX2xlbl90YXJnZXQgKj0gMjsKLQl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBm
b3IgYnVmZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuX3RhcmdldCA9IHN0cm5sZW4oZnJv
bU5hbWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9sZW5fdGFyZ2V0Kys7CS8qIHRyYWlsaW5nIG51bGwg
Ki8KLQkJc3RybmNweShkYXRhX29mZnNldCwgZnJvbU5hbWUsIG5hbWVfbGVuX3RhcmdldCk7CisJ
fSBlbHNlIHsKKwkJbmFtZV9sZW5fdGFyZ2V0ID0gY29weV9wYXRoX25hbWUoZGF0YV9vZmZzZXQs
IGZyb21OYW1lKTsKIAl9CiAKIAlwU01CLT5NYXhQYXJhbWV0ZXJDb3VudCA9IGNwdV90b19sZTE2
KDIpOwpAQCAtMzIxMywxNSArMzE4MCwxMCBAQCBDSUZTQ3JlYXRlSGFyZExpbmsoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkgICAgICAgcmVtYXAp
OwogCQluYW1lX2xlbjIgKz0gMSAvKiB0cmFpbGluZyBudWxsICovICArIDEgLyogU2lnbmF0dXJl
IHdvcmQgKi8gOwogCQluYW1lX2xlbjIgKj0gMjsJLyogY29udmVydCB0byBieXRlcyAqLwotCX0g
ZWxzZSB7CS8qIEJCIGltcHJvdmUgdGhlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8K
LQkJbmFtZV9sZW4gPSBzdHJubGVuKGZyb21fbmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisr
OwkvKiB0cmFpbGluZyBudWxsICovCi0JCXN0cm5jcHkocFNNQi0+T2xkRmlsZU5hbWUsIGZyb21f
bmFtZSwgbmFtZV9sZW4pOwotCQluYW1lX2xlbjIgPSBzdHJubGVuKHRvX25hbWUsIFBBVEhfTUFY
KTsKLQkJbmFtZV9sZW4yKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KKwl9IGVsc2UgeworCQluYW1l
X2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBTTUItPk9sZEZpbGVOYW1lLCBmcm9tX25hbWUpOwogCQlw
U01CLT5PbGRGaWxlTmFtZVtuYW1lX2xlbl0gPSAweDA0OwkvKiAybmQgYnVmZmVyIGZvcm1hdCAq
LwotCQlzdHJuY3B5KCZwU01CLT5PbGRGaWxlTmFtZVtuYW1lX2xlbiArIDFdLCB0b19uYW1lLCBu
YW1lX2xlbjIpOwotCQluYW1lX2xlbjIrKzsJLyogdHJhaWxpbmcgbnVsbCAqLworCQluYW1lX2xl
bjIgPSBjb3B5X3BhdGhfbmFtZShwU01CLT5PbGRGaWxlTmFtZStuYW1lX2xlbisxLCB0b19uYW1l
KTsKIAkJbmFtZV9sZW4yKys7CS8qIHNpZ25hdHVyZSBieXRlICovCiAJfQogCkBAIC0zMjcxLDEw
ICszMjMzLDggQEAgQ0lGU1NNQlVuaXhRdWVyeVN5bUxpbmsoY29uc3QgdW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJICAgcmVtYXApOwogCQluYW1lX2xlbisr
OwkvKiB0cmFpbGluZyBudWxsICovCiAJCW5hbWVfbGVuICo9IDI7Ci0JfSBlbHNlIHsJLyogQkIg
aW1wcm92ZSB0aGUgY2hlY2sgZm9yIGJ1ZmZlciBvdmVycnVucyBCQiAqLwotCQluYW1lX2xlbiA9
IHN0cm5sZW4oc2VhcmNoTmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisrOwkvKiB0cmFpbGlu
ZyBudWxsICovCi0JCXN0cm5jcHkocFNNQi0+RmlsZU5hbWUsIHNlYXJjaE5hbWUsIG5hbWVfbGVu
KTsKKwl9IGVsc2UgeworCQluYW1lX2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBTTUItPkZpbGVOYW1l
LCBzZWFyY2hOYW1lKTsKIAl9CiAKIAlwYXJhbXMgPSAyIC8qIGxldmVsICovICArIDQgLyogcnNy
dmQgKi8gICsgbmFtZV9sZW4gLyogaW5jbCBudWxsICovIDsKQEAgLTM2OTEsMTAgKzM2NTEsOCBA
QCBDSUZTU01CR2V0UG9zaXhBQ0woY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNf
dGNvbiAqdGNvbiwKIAkJbmFtZV9sZW4gKj0gMjsKIAkJcFNNQi0+RmlsZU5hbWVbbmFtZV9sZW5d
ID0gMDsKIAkJcFNNQi0+RmlsZU5hbWVbbmFtZV9sZW4rMV0gPSAwOwotCX0gZWxzZSB7CS8qIEJC
IGltcHJvdmUgdGhlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8KLQkJbmFtZV9sZW4g
PSBzdHJubGVuKHNlYXJjaE5hbWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9sZW4rKzsgICAgIC8qIHRy
YWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5GaWxlTmFtZSwgc2VhcmNoTmFtZSwgbmFt
ZV9sZW4pOworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29weV9wYXRoX25hbWUocFNNQi0+Rmls
ZU5hbWUsIHNlYXJjaE5hbWUpOwogCX0KIAogCXBhcmFtcyA9IDIgLyogbGV2ZWwgKi8gICsgNCAv
KiByc3J2ZCAqLyAgKyBuYW1lX2xlbiAvKiBpbmNsIG51bGwgKi8gOwpAQCAtMzc3NiwxMCArMzcz
NCw4IEBAIENJRlNTTUJTZXRQb3NpeEFDTChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkJCQkgICBQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCByZW1hcCk7
CiAJCW5hbWVfbGVuKys7ICAgICAvKiB0cmFpbGluZyBudWxsICovCiAJCW5hbWVfbGVuICo9IDI7
Ci0JfSBlbHNlIHsJLyogQkIgaW1wcm92ZSB0aGUgY2hlY2sgZm9yIGJ1ZmZlciBvdmVycnVucyBC
QiAqLwotCQluYW1lX2xlbiA9IHN0cm5sZW4oZmlsZU5hbWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9s
ZW4rKzsgICAgIC8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5GaWxlTmFtZSwg
ZmlsZU5hbWUsIG5hbWVfbGVuKTsKKwl9IGVsc2UgeworCQluYW1lX2xlbiA9IGNvcHlfcGF0aF9u
YW1lKHBTTUItPkZpbGVOYW1lLCBmaWxlTmFtZSk7CiAJfQogCXBhcmFtcyA9IDYgKyBuYW1lX2xl
bjsKIAlwU01CLT5NYXhQYXJhbWV0ZXJDb3VudCA9IGNwdV90b19sZTE2KDIpOwpAQCAtNDE4NCw5
ICs0MTQwLDcgQEAgU01CUXVlcnlJbmZvcm1hdGlvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQluYW1lX2xlbisrOyAgICAgLyogdHJhaWxpbmcgbnVs
bCAqLwogCQluYW1lX2xlbiAqPSAyOwogCX0gZWxzZSB7Ci0JCW5hbWVfbGVuID0gc3Rybmxlbihz
ZWFyY2hfbmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisrOyAgICAgLyogdHJhaWxpbmcgbnVs
bCAqLwotCQlzdHJuY3B5KHBTTUItPkZpbGVOYW1lLCBzZWFyY2hfbmFtZSwgbmFtZV9sZW4pOwor
CQluYW1lX2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBTTUItPkZpbGVOYW1lLCBzZWFyY2hfbmFtZSk7
CiAJfQogCXBTTUItPkJ1ZmZlckZvcm1hdCA9IDB4MDQ7CiAJbmFtZV9sZW4rKzsgLyogYWNjb3Vu
dCBmb3IgYnVmZmVyIHR5cGUgYnl0ZSAqLwpAQCAtNDMyMSwxMCArNDI3NSw4IEBAIENJRlNTTUJR
UGF0aEluZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
IAkJCQkgICAgICAgUEFUSF9NQVgsIG5sc19jb2RlcGFnZSwgcmVtYXApOwogCQluYW1lX2xlbisr
OwkvKiB0cmFpbGluZyBudWxsICovCiAJCW5hbWVfbGVuICo9IDI7Ci0JfSBlbHNlIHsJLyogQkIg
aW1wcm92ZSB0aGUgY2hlY2sgZm9yIGJ1ZmZlciBvdmVycnVucyBCQiAqLwotCQluYW1lX2xlbiA9
IHN0cm5sZW4oc2VhcmNoX25hbWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9sZW4rKzsJLyogdHJhaWxp
bmcgbnVsbCAqLwotCQlzdHJuY3B5KHBTTUItPkZpbGVOYW1lLCBzZWFyY2hfbmFtZSwgbmFtZV9s
ZW4pOworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29weV9wYXRoX25hbWUocFNNQi0+RmlsZU5h
bWUsIHNlYXJjaF9uYW1lKTsKIAl9CiAKIAlwYXJhbXMgPSAyIC8qIGxldmVsICovICsgNCAvKiBy
ZXNlcnZlZCAqLyArIG5hbWVfbGVuIC8qIGluY2x1ZGVzIE5VTCAqLzsKQEAgLTQ0OTAsMTAgKzQ0
NDIsOCBAQCBDSUZTU01CVW5peFFQYXRoSW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCSAgICAgICBQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCBy
ZW1hcCk7CiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0g
MjsKLQl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5z
IEJCICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihzZWFyY2hOYW1lLCBQQVRIX01BWCk7Ci0JCW5h
bWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5GaWxlTmFtZSwg
c2VhcmNoTmFtZSwgbmFtZV9sZW4pOworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29weV9wYXRo
X25hbWUocFNNQi0+RmlsZU5hbWUsIHNlYXJjaE5hbWUpOwogCX0KIAogCXBhcmFtcyA9IDIgLyog
bGV2ZWwgKi8gKyA0IC8qIHJlc2VydmVkICovICsgbmFtZV9sZW4gLyogaW5jbHVkZXMgTlVMICov
OwpAQCAtNDU5MywxNyArNDU0MywxNiBAQCBDSUZTRmluZEZpcnN0KGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQlwU01CLT5GaWxlTmFtZVtuYW1lX2xl
bisxXSA9IDA7CiAJCQluYW1lX2xlbiArPSAyOwogCQl9Ci0JfSBlbHNlIHsJLyogQkIgYWRkIGNo
ZWNrIGZvciBvdmVycnVuIG9mIFNNQiBidWYgQkIgKi8KLQkJbmFtZV9sZW4gPSBzdHJubGVuKHNl
YXJjaE5hbWUsIFBBVEhfTUFYKTsKLS8qIEJCIGZpeCBoZXJlIGFuZCBpbiB1bmljb2RlIGNsYXVz
ZSBhYm92ZSBpZQotCQlpZiAobmFtZV9sZW4gPiBidWZmZXJzaXplLWhlYWRlcikKLQkJCWZyZWUg
YnVmZmVyIGV4aXQ7IEJCICovCi0JCXN0cm5jcHkocFNNQi0+RmlsZU5hbWUsIHNlYXJjaE5hbWUs
IG5hbWVfbGVuKTsKKwl9IGVsc2UgeworCQluYW1lX2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBTTUIt
PkZpbGVOYW1lLCBzZWFyY2hOYW1lKTsKIAkJaWYgKG1zZWFyY2gpIHsKLQkJCXBTTUItPkZpbGVO
YW1lW25hbWVfbGVuXSA9IENJRlNfRElSX1NFUChjaWZzX3NiKTsKLQkJCXBTTUItPkZpbGVOYW1l
W25hbWVfbGVuKzFdID0gJyonOwotCQkJcFNNQi0+RmlsZU5hbWVbbmFtZV9sZW4rMl0gPSAwOwot
CQkJbmFtZV9sZW4gKz0gMzsKKwkJCWlmIChXQVJOX09OX09OQ0UobmFtZV9sZW4gPiBQQVRIX01B
WC0yKSkKKwkJCQluYW1lX2xlbiA9IFBBVEhfTUFYLTI7CisJCQkvKiBvdmVyd3JpdGUgbnVsIGJ5
dGUgKi8KKwkJCXBTTUItPkZpbGVOYW1lW25hbWVfbGVuLTFdID0gQ0lGU19ESVJfU0VQKGNpZnNf
c2IpOworCQkJcFNNQi0+RmlsZU5hbWVbbmFtZV9sZW5dID0gJyonOworCQkJcFNNQi0+RmlsZU5h
bWVbbmFtZV9sZW4rMV0gPSAwOworCQkJbmFtZV9sZW4gKz0gMjsKIAkJfQogCX0KIApAQCAtNDg5
OCwxMCArNDg0Nyw4IEBAIENJRlNHZXRTcnZJbm9kZU51bWJlcihjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQkgICByZW1hcCk7CiAJCW5hbWVfbGVu
Kys7ICAgICAvKiB0cmFpbGluZyBudWxsICovCiAJCW5hbWVfbGVuICo9IDI7Ci0JfSBlbHNlIHsJ
LyogQkIgaW1wcm92ZSB0aGUgY2hlY2sgZm9yIGJ1ZmZlciBvdmVycnVucyBCQiAqLwotCQluYW1l
X2xlbiA9IHN0cm5sZW4oc2VhcmNoX25hbWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9sZW4rKzsgICAg
IC8qIHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5GaWxlTmFtZSwgc2VhcmNoX25h
bWUsIG5hbWVfbGVuKTsKKwl9IGVsc2UgeworCQluYW1lX2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBT
TUItPkZpbGVOYW1lLCBzZWFyY2hfbmFtZSk7CiAJfQogCiAJcGFyYW1zID0gMiAvKiBsZXZlbCAq
LyAgKyA0IC8qIHJzcnZkICovICArIG5hbWVfbGVuIC8qIGluY2wgbnVsbCAqLyA7CkBAIC01MDA4
LDkgKzQ5NTUsNyBAQCBDSUZTR2V0REZTUmVmZXIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfc2VzICpzZXMsCiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJ
bmFtZV9sZW4gKj0gMjsKIAl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3IgYnVm
ZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihzZWFyY2hfbmFtZSwgUEFU
SF9NQVgpOwotCQluYW1lX2xlbisrOwkvKiB0cmFpbGluZyBudWxsICovCi0JCXN0cm5jcHkocFNN
Qi0+UmVxdWVzdEZpbGVOYW1lLCBzZWFyY2hfbmFtZSwgbmFtZV9sZW4pOworCQluYW1lX2xlbiA9
IGNvcHlfcGF0aF9uYW1lKHBTTUItPlJlcXVlc3RGaWxlTmFtZSwgc2VhcmNoX25hbWUpOwogCX0K
IAogCWlmIChzZXMtPnNlcnZlci0+c2lnbikKQEAgLTU2NjMsMTAgKzU2MDgsOCBAQCBDSUZTU01C
U2V0RU9GKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CQkJICAgICAgIFBBVEhfTUFYLCBjaWZzX3NiLT5sb2NhbF9ubHMsIHJlbWFwKTsKIAkJbmFtZV9s
ZW4rKzsJLyogdHJhaWxpbmcgbnVsbCAqLwogCQluYW1lX2xlbiAqPSAyOwotCX0gZWxzZSB7CS8q
IEJCIGltcHJvdmUgdGhlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8KLQkJbmFtZV9s
ZW4gPSBzdHJubGVuKGZpbGVfbmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xlbisrOwkvKiB0cmFp
bGluZyBudWxsICovCi0JCXN0cm5jcHkocFNNQi0+RmlsZU5hbWUsIGZpbGVfbmFtZSwgbmFtZV9s
ZW4pOworCX0gZWxzZSB7CisJCW5hbWVfbGVuID0gY29weV9wYXRoX25hbWUocFNNQi0+RmlsZU5h
bWUsIGZpbGVfbmFtZSk7CiAJfQogCXBhcmFtcyA9IDYgKyBuYW1lX2xlbjsKIAlkYXRhX2NvdW50
ID0gc2l6ZW9mKHN0cnVjdCBmaWxlX2VuZF9vZl9maWxlX2luZm8pOwpAQCAtNTk1OSwxMCArNTkw
Miw4IEBAIENJRlNTTUJTZXRQYXRoSW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkJCSAgICAgICBQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCByZW1h
cCk7CiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsK
LQl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5zIEJC
ICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihmaWxlTmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xl
bisrOwkvKiB0cmFpbGluZyBudWxsICovCi0JCXN0cm5jcHkocFNNQi0+RmlsZU5hbWUsIGZpbGVO
YW1lLCBuYW1lX2xlbik7CisJfSBlbHNlIHsKKwkJbmFtZV9sZW4gPSBjb3B5X3BhdGhfbmFtZShw
U01CLT5GaWxlTmFtZSwgZmlsZU5hbWUpOwogCX0KIAogCXBhcmFtcyA9IDYgKyBuYW1lX2xlbjsK
QEAgLTYwNDAsMTAgKzU5ODEsOCBAQCBDSUZTU01CU2V0QXR0ckxlZ2FjeSh1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjaGFyICpmaWxlTmFtZSwKIAkJCQkgICAgICAg
UEFUSF9NQVgsIG5sc19jb2RlcGFnZSk7CiAJCW5hbWVfbGVuKys7ICAgICAvKiB0cmFpbGluZyBu
dWxsICovCiAJCW5hbWVfbGVuICo9IDI7Ci0JfSBlbHNlIHsJLyogQkIgaW1wcm92ZSB0aGUgY2hl
Y2sgZm9yIGJ1ZmZlciBvdmVycnVucyBCQiAqLwotCQluYW1lX2xlbiA9IHN0cm5sZW4oZmlsZU5h
bWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9sZW4rKzsgICAgIC8qIHRyYWlsaW5nIG51bGwgKi8KLQkJ
c3RybmNweShwU01CLT5maWxlTmFtZSwgZmlsZU5hbWUsIG5hbWVfbGVuKTsKKwl9IGVsc2Ugewor
CQluYW1lX2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBTTUItPmZpbGVOYW1lLCBmaWxlTmFtZSk7CiAJ
fQogCXBTTUItPmF0dHIgPSBjcHVfdG9fbGUxNihkb3NfYXR0cnMpOwogCXBTTUItPkJ1ZmZlckZv
cm1hdCA9IDB4MDQ7CkBAIC02MjAzLDEwICs2MTQyLDggQEAgQ0lGU1NNQlVuaXhTZXRQYXRoSW5m
byhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCSAg
ICAgICBQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCByZW1hcCk7CiAJCW5hbWVfbGVuKys7CS8qIHRy
YWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsKLQl9IGVsc2UgewkvKiBCQiBpbXByb3Zl
IHRoZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5zIEJCICovCi0JCW5hbWVfbGVuID0gc3Rybmxl
bihmaWxlX25hbWUsIFBBVEhfTUFYKTsKLQkJbmFtZV9sZW4rKzsJLyogdHJhaWxpbmcgbnVsbCAq
LwotCQlzdHJuY3B5KHBTTUItPkZpbGVOYW1lLCBmaWxlX25hbWUsIG5hbWVfbGVuKTsKKwl9IGVs
c2UgeworCQluYW1lX2xlbiA9IGNvcHlfcGF0aF9uYW1lKHBTTUItPkZpbGVOYW1lLCBmaWxlX25h
bWUpOwogCX0KIAogCXBhcmFtcyA9IDYgKyBuYW1lX2xlbjsKQEAgLTYyOTgsMTAgKzYyMzUsOCBA
QCBDSUZTU01CUUFsbEVBcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkJCSAgICAgICBQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCByZW1hcCk7CiAJCWxp
c3RfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJbGlzdF9sZW4gKj0gMjsKLQl9IGVsc2Ug
ewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5zIEJCICovCi0JCWxp
c3RfbGVuID0gc3RybmxlbihzZWFyY2hOYW1lLCBQQVRIX01BWCk7Ci0JCWxpc3RfbGVuKys7CS8q
IHRyYWlsaW5nIG51bGwgKi8KLQkJc3RybmNweShwU01CLT5GaWxlTmFtZSwgc2VhcmNoTmFtZSwg
bGlzdF9sZW4pOworCX0gZWxzZSB7CisJCWxpc3RfbGVuID0gY29weV9wYXRoX25hbWUocFNNQi0+
RmlsZU5hbWUsIHNlYXJjaE5hbWUpOwogCX0KIAogCXBhcmFtcyA9IDIgLyogbGV2ZWwgKi8gKyA0
IC8qIHJlc2VydmVkICovICsgbGlzdF9sZW4gLyogaW5jbHVkZXMgTlVMICovOwpAQCAtNjQ4MCwx
MCArNjQxNSw4IEBAIENJRlNTTUJTZXRFQShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkJCSAgICAgICBQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCByZW1h
cCk7CiAJCW5hbWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsK
LQl9IGVsc2UgewkvKiBCQiBpbXByb3ZlIHRoZSBjaGVjayBmb3IgYnVmZmVyIG92ZXJydW5zIEJC
ICovCi0JCW5hbWVfbGVuID0gc3RybmxlbihmaWxlTmFtZSwgUEFUSF9NQVgpOwotCQluYW1lX2xl
bisrOwkvKiB0cmFpbGluZyBudWxsICovCi0JCXN0cm5jcHkocFNNQi0+RmlsZU5hbWUsIGZpbGVO
YW1lLCBuYW1lX2xlbik7CisJfSBlbHNlIHsKKwkJbmFtZV9sZW4gPSBjb3B5X3BhdGhfbmFtZShw
U01CLT5GaWxlTmFtZSwgZmlsZU5hbWUpOwogCX0KIAogCXBhcmFtcyA9IDYgKyBuYW1lX2xlbjsK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
ZGRlZmRkZWZmZDA2Li5hOGIxNzY3YjYwZjAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC00MjMxLDE2ICs0MjMxLDE5IEBAIGJ1aWxkX3Vu
Y19wYXRoX3RvX3Jvb3QoY29uc3Qgc3RydWN0IHNtYl92b2wgKnZvbCwKIAkJc3RybGVuKHZvbC0+
cHJlcGF0aCkgKyAxIDogMDsKIAl1bnNpZ25lZCBpbnQgdW5jX2xlbiA9IHN0cm5sZW4odm9sLT5V
TkMsIE1BWF9UUkVFX1NJWkUgKyAxKTsKIAorCWlmICh1bmNfbGVuID4gTUFYX1RSRUVfU0laRSkK
KwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7CisKIAlmdWxsX3BhdGggPSBrbWFsbG9jKHVuY19s
ZW4gKyBwcGxlbiArIDEsIEdGUF9LRVJORUwpOwogCWlmIChmdWxsX3BhdGggPT0gTlVMTCkKIAkJ
cmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7CiAKLQlzdHJuY3B5KGZ1bGxfcGF0aCwgdm9sLT5VTkMs
IHVuY19sZW4pOworCW1lbWNweShmdWxsX3BhdGgsIHZvbC0+VU5DLCB1bmNfbGVuKTsKIAlwb3Mg
PSBmdWxsX3BhdGggKyB1bmNfbGVuOwogCiAJaWYgKHBwbGVuKSB7CiAJCSpwb3MgPSBDSUZTX0RJ
Ul9TRVAoY2lmc19zYik7Ci0JCXN0cm5jcHkocG9zICsgMSwgdm9sLT5wcmVwYXRoLCBwcGxlbik7
CisJCW1lbWNweShwb3MgKyAxLCB2b2wtPnByZXBhdGgsIHBwbGVuKTsKIAkJcG9zICs9IHBwbGVu
OwogCX0KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9kaXIuYyBiL2ZzL2NpZnMvZGlyLmMKaW5kZXgg
ZjI2YTQ4ZGQyZTM5Li5iZTQyNGU4MWUzYWQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysr
IGIvZnMvY2lmcy9kaXIuYwpAQCAtNjksMTEgKzY5LDEwIEBAIGNpZnNfYnVpbGRfcGF0aF90b19y
b290KHN0cnVjdCBzbWJfdm9sICp2b2wsIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsCiAJ
CXJldHVybiBmdWxsX3BhdGg7CiAKIAlpZiAoZGZzcGxlbikKLQkJc3RybmNweShmdWxsX3BhdGgs
IHRjb24tPnRyZWVOYW1lLCBkZnNwbGVuKTsKKwkJbWVtY3B5KGZ1bGxfcGF0aCwgdGNvbi0+dHJl
ZU5hbWUsIGRmc3BsZW4pOwogCWZ1bGxfcGF0aFtkZnNwbGVuXSA9IENJRlNfRElSX1NFUChjaWZz
X3NiKTsKLQlzdHJuY3B5KGZ1bGxfcGF0aCArIGRmc3BsZW4gKyAxLCB2b2wtPnByZXBhdGgsIHBw
bGVuKTsKKwltZW1jcHkoZnVsbF9wYXRoICsgZGZzcGxlbiArIDEsIHZvbC0+cHJlcGF0aCwgcHBs
ZW4pOwogCWNvbnZlcnRfZGVsaW1pdGVyKGZ1bGxfcGF0aCwgQ0lGU19ESVJfU0VQKGNpZnNfc2Ip
KTsKLQlmdWxsX3BhdGhbZGZzcGxlbiArIHBwbGVuXSA9IDA7IC8qIGFkZCB0cmFpbGluZyBudWxs
ICovCiAJcmV0dXJuIGZ1bGxfcGF0aDsKIH0KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9taXNjLmMg
Yi9mcy9jaWZzL21pc2MuYwppbmRleCBmMzgzODc3YTY1MTEuLjVhZDgzYmRiOWJlYSAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9taXNjLmMKKysrIGIvZnMvY2lmcy9taXNjLmMKQEAgLTEwMTEsMyArMTAx
MSwyNSBAQCB2b2lkIGV4dHJhY3RfdW5jX2hvc3RuYW1lKGNvbnN0IGNoYXIgKnVuYywgY29uc3Qg
Y2hhciAqKmgsIHNpemVfdCAqbGVuKQogCSpoID0gdW5jOwogCSpsZW4gPSBlbmQgLSB1bmM7CiB9
CisKKy8qKgorICogY29weV9wYXRoX25hbWUgLSBjb3B5IHNyYyBwYXRoIHRvIGRzdCwgcG9zc2li
bHkgdHJ1bmNhdGluZworICoKKyAqIHJldHVybnMgbnVtYmVyIG9mIGJ5dGVzIHdyaXR0ZW4gKGlu
Y2x1ZGluZyB0cmFpbGluZyBudWwpCisgKi8KK2ludCBjb3B5X3BhdGhfbmFtZShjaGFyICpkc3Qs
IGNvbnN0IGNoYXIgKnNyYykKK3sKKwlpbnQgbmFtZV9sZW47CisKKwkvKgorCSAqIFBBVEhfTUFY
IGluY2x1ZGVzIG51bCwgc28gaWYgc3RybGVuKHNyYykgPj0gUEFUSF9NQVggaXQKKwkgKiB3aWxs
IHRydW5jYXRlIGFuZCBzdHJsZW4oZHN0KSB3aWxsIGJlIFBBVEhfTUFYLTEKKwkgKi8KKwluYW1l
X2xlbiA9IHN0cnNjcHkoZHN0LCBzcmMsIFBBVEhfTUFYKTsKKwlpZiAoV0FSTl9PTl9PTkNFKG5h
bWVfbGVuIDwgMCkpCisJCW5hbWVfbGVuID0gUEFUSF9NQVgtMTsKKworCS8qIHdlIGNvdW50IHRo
ZSB0cmFpbGluZyBudWwgKi8KKwluYW1lX2xlbisrOworCXJldHVybiBuYW1lX2xlbjsKK30KZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvc2Vzcy5jIGIvZnMvY2lmcy9zZXNzLmMKaW5kZXggZGNkNDlhZDYw
YzgzLi40Yzc2NGZmN2VkZDIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc2Vzcy5jCisrKyBiL2ZzL2Np
ZnMvc2Vzcy5jCkBAIC0xNTksMTMgKzE1OSwxNiBAQCBzdGF0aWMgdm9pZCBhc2NpaV9zc2V0dXBf
c3RyaW5ncyhjaGFyICoqcGJjY19hcmVhLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJCQkgY29u
c3Qgc3RydWN0IG5sc190YWJsZSAqbmxzX2NwKQogewogCWNoYXIgKmJjY19wdHIgPSAqcGJjY19h
cmVhOworCWludCBsZW47CiAKIAkvKiBjb3B5IHVzZXIgKi8KIAkvKiBCQiB3aGF0IGFib3V0IG51
bGwgdXNlciBtb3VudHMgLSBjaGVjayB0aGF0IHdlIGRvIHRoaXMgQkIgKi8KIAkvKiBjb3B5IHVz
ZXIgKi8KIAlpZiAoc2VzLT51c2VyX25hbWUgIT0gTlVMTCkgewotCQlzdHJuY3B5KGJjY19wdHIs
IHNlcy0+dXNlcl9uYW1lLCBDSUZTX01BWF9VU0VSTkFNRV9MRU4pOwotCQliY2NfcHRyICs9IHN0
cm5sZW4oc2VzLT51c2VyX25hbWUsIENJRlNfTUFYX1VTRVJOQU1FX0xFTik7CisJCWxlbiA9IHN0
cnNjcHkoYmNjX3B0ciwgc2VzLT51c2VyX25hbWUsIENJRlNfTUFYX1VTRVJOQU1FX0xFTik7CisJ
CWlmIChXQVJOX09OX09OQ0UobGVuIDwgMCkpCisJCQlsZW4gPSBDSUZTX01BWF9VU0VSTkFNRV9M
RU4gLSAxOworCQliY2NfcHRyICs9IGxlbjsKIAl9CiAJLyogZWxzZSBudWxsIHVzZXIgbW91bnQg
Ki8KIAkqYmNjX3B0ciA9IDA7CkBAIC0xNzMsOCArMTc2LDEwIEBAIHN0YXRpYyB2b2lkIGFzY2lp
X3NzZXR1cF9zdHJpbmdzKGNoYXIgKipwYmNjX2FyZWEsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAog
CiAJLyogY29weSBkb21haW4gKi8KIAlpZiAoc2VzLT5kb21haW5OYW1lICE9IE5VTEwpIHsKLQkJ
c3RybmNweShiY2NfcHRyLCBzZXMtPmRvbWFpbk5hbWUsIENJRlNfTUFYX0RPTUFJTk5BTUVfTEVO
KTsKLQkJYmNjX3B0ciArPSBzdHJubGVuKHNlcy0+ZG9tYWluTmFtZSwgQ0lGU19NQVhfRE9NQUlO
TkFNRV9MRU4pOworCQlsZW4gPSBzdHJzY3B5KGJjY19wdHIsIHNlcy0+ZG9tYWluTmFtZSwgQ0lG
U19NQVhfRE9NQUlOTkFNRV9MRU4pOworCQlpZiAoV0FSTl9PTl9PTkNFKGxlbiA8IDApKQorCQkJ
bGVuID0gQ0lGU19NQVhfRE9NQUlOTkFNRV9MRU4gLSAxOworCQliY2NfcHRyICs9IGxlbjsKIAl9
IC8qIGVsc2Ugd2Ugd2lsbCBzZW5kIGEgbnVsbCBkb21haW4gbmFtZQogCSAgICAgc28gdGhlIHNl
cnZlciB3aWxsIGRlZmF1bHQgdG8gaXRzIG93biBkb21haW4gKi8KIAkqYmNjX3B0ciA9IDA7CkBA
IC0yNDIsOSArMjQ3LDEwIEBAIHN0YXRpYyB2b2lkIGRlY29kZV9hc2NpaV9zc2V0dXAoY2hhciAq
KnBiY2NfYXJlYSwgX191MTYgYmxlZnQsCiAKIAlrZnJlZShzZXMtPnNlcnZlck9TKTsKIAotCXNl
cy0+c2VydmVyT1MgPSBremFsbG9jKGxlbiArIDEsIEdGUF9LRVJORUwpOworCXNlcy0+c2VydmVy
T1MgPSBrbWFsbG9jKGxlbiArIDEsIEdGUF9LRVJORUwpOwogCWlmIChzZXMtPnNlcnZlck9TKSB7
Ci0JCXN0cm5jcHkoc2VzLT5zZXJ2ZXJPUywgYmNjX3B0ciwgbGVuKTsKKwkJbWVtY3B5KHNlcy0+
c2VydmVyT1MsIGJjY19wdHIsIGxlbik7CisJCXNlcy0+c2VydmVyT1NbbGVuXSA9IDA7CiAJCWlm
IChzdHJuY21wKHNlcy0+c2VydmVyT1MsICJPUy8yIiwgNCkgPT0gMCkKIAkJCWNpZnNfZGJnKEZZ
SSwgIk9TLzIgc2VydmVyXG4iKTsKIAl9CkBAIC0yNTgsOSArMjY0LDExIEBAIHN0YXRpYyB2b2lk
IGRlY29kZV9hc2NpaV9zc2V0dXAoY2hhciAqKnBiY2NfYXJlYSwgX191MTYgYmxlZnQsCiAKIAlr
ZnJlZShzZXMtPnNlcnZlck5PUyk7CiAKLQlzZXMtPnNlcnZlck5PUyA9IGt6YWxsb2MobGVuICsg
MSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKHNlcy0+c2VydmVyTk9TKQotCQlzdHJuY3B5KHNlcy0+c2Vy
dmVyTk9TLCBiY2NfcHRyLCBsZW4pOworCXNlcy0+c2VydmVyTk9TID0ga21hbGxvYyhsZW4gKyAx
LCBHRlBfS0VSTkVMKTsKKwlpZiAoc2VzLT5zZXJ2ZXJOT1MpIHsKKwkJbWVtY3B5KHNlcy0+c2Vy
dmVyTk9TLCBiY2NfcHRyLCBsZW4pOworCQlzZXMtPnNlcnZlck5PU1tsZW5dID0gMDsKKwl9CiAK
IAliY2NfcHRyICs9IGxlbiArIDE7CiAJYmxlZnQgLT0gbGVuICsgMTsKLS0gCjIuMjAuMQoK
--000000000000b9e927059120df76--
