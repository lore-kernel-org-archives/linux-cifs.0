Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFB53546EA
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 04:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792212179; cv=pass; b=DBng5ppOEw0wEjXFEqgOw2uba82Vuivo5/bbk/AyZvpkKkfVYlj2fRAeZpWKFCgtKQBqVARgqDBxrkWZf/gtMQvPkiCKBciuaOBiZwGn2kG3a3+Sy8wmG+XmfMkWBwV3GnfB37H4OINz+v7gZSa6mAhcQiJjQ4fdFiUv3BhTpwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792212179; c=relaxed/simple;
	bh=nvfkS/PbPdRIPJQqXsJRdEzX0IF841PEvFdhX4ItgNY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hle2UJpvBS3uP22qYq9lJedCcykiSopTIjnxs0b3X7+NV51vmD3pF5tvR6+F8RSOHqgU/AllohnsZmLXwgIRHmaStmdHnXXgz4bKzMo+jzShlR3K9jxaeKrWNlzPgSv6WFF0t4MgMZtc2DOX8+T1d4Eme3CytTm6A01OXLJ5ekk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYfyqvKK; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYfyqvKK"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b0a921ee46so4635147b3.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 21:42:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792212176; cv=none;
        d=google.com; s=arc-20260327;
        b=dS+KjjGHvU2JaSDZF4afgtapzj5NxUHa6iaaXOuNpQ7nBaEW62aJhYzwY/mpgVi3mw
         p9BQxNNJwo09+deSPcU6/0LMuURGWNWXEZmo3m60ZcYri3cPRyVEfqzs69Jy8jGbNkuF
         6eFQLDC+eZX4g9EZmwMHwnwMVWCzIEBzRYmG72g8qG6ykiZJ7XdEC/TSY0Y6hQUW755A
         p/RU5ebzHG3ULrwaxh9hWVdtNIfmjebqQ30nwYi91y6q7m5vOezpPQHnGUuUko0Ecviw
         6RI5rpSGJMG0jYKzARjWvuVLolNOYFt1bkjcfTMrDOqZn3MNTgpR4qgWIEw+jPIQEglD
         Ifgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Uh/GVxZjnU6z/3b98dpSkIACi2Ik+1ig9vewyhqQMhY=;
        fh=MKY6YH3ZWmP6GACBDJJmpEhxGDIksJn+5CQsVu+bTgc=;
        b=ZVXTsOAIpijAQBFHtFns4meSivK/mIFu77nNp16WmIjdtfzH9mD5xfEPfLW26193yf
         s9QsxI/0vq5UlmxSj4lMf6w52+vbD59RD/G1pgygLvxB8vP37ZfoLOq7PmIKtiJ/uV41
         w7nJAL3AVl0FSGmFms1cEIFwrBWBRaIUnfj+vCBSRl+eKYX3xQz5w/VGh7vHMTTaFo4l
         2UKGpaShdm/fmYr2umjplwelriVI4hzxBiG/bPGwYFaVi5Q4FMvlbQ/ptlW4VG38wa75
         X9R8mm6hBEC5kMZk/qQFnmiNwepxVIMH2nEmp4lga+cW6uP+gHnJ3WEO4cU5+tfnEeAN
         5kgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792212176; x=1792816976; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uh/GVxZjnU6z/3b98dpSkIACi2Ik+1ig9vewyhqQMhY=;
        b=UYfyqvKKyEfE5cdl3LGlUsH30oQD+7K5sXQTnPdcNimPZlPS0O/c0fWL6cuj6fPtid
         HOBGKevWfgL+XGwQve8xXhscbqzjsJNu2ZsT4KxGYhE7L4FDKLa+xOPBBJ3gc5JVhuNY
         xaYGC6jFcoKDFgAlA8VhEmTZ+sFm1d8LYtjmGTIfTdU/seUQ+/4M1dLR5dO0hUAVeNZY
         CjX8uxb9WE6bjPT2KY+OsGWpaWB43nY+jkqng9XpoNNkfSF2D7ejlu52lVnc9VwOCuWu
         vTWMcAfWl+AIWsyGuQ8rMgXzO3oApqXG4MuAKnhASg4ewtCFClLBAMu7lHdTyaRPicNX
         zukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792212176; x=1792816976;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Uh/GVxZjnU6z/3b98dpSkIACi2Ik+1ig9vewyhqQMhY=;
        b=tK1yyxhj51jqnegjMYRnfaoFkF4C1GNjIMAP4mSw4O2RBseEcJwv+Ok5yZUXZuCe+f
         ibHx6XRNDOgdQTgPef72ew4sB/ydBlcLjvJ5znMxaoetvwNRkhauFjiYD6vuHS76IUU5
         QTwcklt1CjfUAKH1F2PzO+EbQ5yVBrzzN/Sqdha8E7PFlySKCPfTXuUNygG6xOqTvGk+
         aUZPUL798guC727aPbI72TLuyPBLKqEMB7CcJWg1pv3m8eMNbJu1HJ4nC4XffP0bwixh
         ADYfxCNTltB77RSyhJf7UOInEW1Z92EnYiOnMYDtTY5ZR5kcEsTNkS5XuBtvg99L7SQs
         7jhA==
X-Forwarded-Encrypted: i=1; AKwUvBzQ730B26gyticc0bWP2fMBEPuoOBckvwebH5cNGhEZLg3dBli4yStEh/ZJ2DymMl0U+X+RtTzkdGkX@vger.kernel.org
X-Gm-Message-State: AFq9FYKSlioQYsKsZVGULCeu1vBES29vCzlnU5yMBU2fdVTlIHxD1b+w
	2hwexhbdILJNyivdDrbWqls498r7bLHcvhNo1WUFOuiVpybiGvJLVcEnXh7+3lKvVNVaCH5cvdV
	mQsB9dkQ9sBkUCJfkaMVgc2doJawwRHI=
X-Gm-Gg: AYBFou3g9h66+AnjNBEWgn++e1RyVPHsbWUue3VjRt4mplgNR8ic6TH6P6Y+DdFb/wg
	S/BbMtfmbIdOCuTVyjsmhQcPcIBcsLPZTxUTCt+Cq1Mh2AimjBicOXK0JyAQUmdiKjAE5DUshUJ
	CDDZ9j4en2wE9PnvO2xyZ2YOTY2Nasm3vS4j1rDB8zocPebo46qxTtM3qKUb5GjEfvHflHXiF2T
	wpmMo9NSgCA+EbfL6tP8pnNuanVGHdH+E9oHam1IuxMf5Fu+l4kGiQ/+1V4V02Y/BX8N72XY0LD
	a7yj/OYgs0NAjJfYBxdmkJkCcQi+bpu23Py+0SZ3hEI97dGsm1N2kPbI467+D7Kkzx/FriN9NfX
	KKYq7YnD56muvurJGiOLnkrIgtaMHTFlQKqUAH/sMAs2gHuLROw==
X-Received: by 2002:a05:690c:a4c5:b0:8b0:cf3d:7b35 with SMTP id
 00721157ae682-8b0f2074384mr4926687b3.15.1792212176537; Fri, 16 Oct 2026
 21:42:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Sat, 17 Oct 2026 14:42:45 +1000
X-Gm-Features: AclHuK93DYXTF16ik09W6YeUDi6L52MGyp2DqfqOwvdc-ozmEuPeAyiQQHALves
Message-ID: <CAN05THQKjL8oyGH1N-K4TTT9cQErNJaz4SO91uP_QHRmRGhG6g@mail.gmail.com>
Subject: ksmbd: related compound QUERY_INFO fails with STATUS_FILE_CLOSED when
 the previous operation is not a CREATE
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	chenxiaosong@chenxiaosong.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

ksmbd rejects a related compound request that Windows and Samba accept,
and that MS-SMB2 says the server must accept. It showed up as a libsmb2
regression: our fstat sends two QUERY_INFO requests on an already open
handle as a related compound, and against ksmbd the second one fails.
(libsmb2 now works around it by sending the two as an unrelated
compound, so nothing is urgent on our side.)

The sequence, on a file already opened by an earlier, separate CREATE:

  1. QUERY_INFO  FileAttributeTagInformation   FileId = <real handle>
  2. QUERY_INFO  FileAllInformation            FileId = 0xFFFFFFFFFFFFFFFF
                                               SMB2_FLAGS_RELATED_OPERATIONS

Results:

  Windows Server 2016:            1 STATUS_SUCCESS, 2 STATUS_SUCCESS
  Samba 4.24.7:                   1 STATUS_SUCCESS, 2 STATUS_SUCCESS
  ksmbd, Debian 6.12.107 (TCP):   1 STATUS_SUCCESS, 2 STATUS_FILE_CLOSED
  ksmbd, same, SMB Direct (RoCE): 1 STATUS_SUCCESS, 2 STATUS_FILE_CLOSED

MS-SMB2 3.3.5.2.7.2 "Handling Compounded Related Requests":

  For every subsequent operation, the values used for FileId,
  SessionId, and TreeId MUST be the ones used in processing the
  previous operation or generated for the previous resulting response.

  When the current operation requires a FileId, and if the previous
  operation neither contains nor generates a FileId, the server MUST
  fail the current operation and all subsequent operations with
  STATUS_INVALID_HANDLE.

So a FileId that the previous request contains counts the same as one
a CREATE generates. Here request 1 contains one, so request 2 should
run on that handle.

Looking at fs/smb/server/smb2pdu.c (I have only tested 6.12, master is
from reading the source):

 - In 6.12, init_chained_smb2_rsp() sets work->compound_fid only after
   a successful CREATE.
 - In master it is also set from the FileId of a successful FLUSH, READ
   or WRITE, but not after QUERY_INFO, SET_INFO, IOCTL, LOCK or
   QUERY_DIRECTORY, which also contain a FileId.

So in master the sequence above should still fail.
smb2_get_info_file() finds no compound_fid, falls back to
req->VolatileFileId, which is the 0xFFFFFFFFFFFFFFFF placeholder,
ksmbd_lookup_fd_slow() fails, and smb2_query_info() maps -ENOENT to
STATUS_FILE_CLOSED.

The natural fix seems to be to do what master already does for
FLUSH/READ/WRITE for every request that contains a FileId. Separately,
when there really is no FileId to inherit, the spec asks for
STATUS_INVALID_HANDLE rather than STATUS_FILE_CLOSED.

Reproducer
----------

Below is a small program against libsmb2's public API. It opens a
file, sends the related compound above and, as a control, the same two
queries as an unrelated compound with the real FileId in both. It
prints the status of each reply and exits 0 on PASS, 1 if the related
compound is rejected.

Build (libsmb2 master, https://github.com/sahlberg/libsmb2):

  git clone https://github.com/sahlberg/libsmb2
  cd libsmb2 && sh bootstrap && ./configure && make && sudo make install
  export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig   # default prefix
  gcc -o smb2-related-qi smb2-related-qi.c \
      $(pkg-config --cflags --libs libsmb2)

Run (any existing file on the share; the password comes from a file
with DOMAIN:USERNAME:PASSWORD lines):

  echo ':user:password' > ntlm
  NTLM_USER_FILE=ntlm ./smb2-related-qi smb://user@server/share/file

Output against ksmbd:

  Related compound:
    QUERY_INFO FileAttributeTagInformation   FileId <real>
-> 0x00000000 STATUS_SUCCESS
    QUERY_INFO FileAllInformation            FileId 0xFFFFFFFFFFFFFFFF
-> 0xc0000128 STATUS_FILE_CLOSED
  Unrelated compound:
    QUERY_INFO FileAttributeTagInformation   FileId <real>
-> 0x00000000 STATUS_SUCCESS
    QUERY_INFO FileAllInformation            FileId <real>
-> 0x00000000 STATUS_SUCCESS
  FAIL: related compound rejected

Against Windows Server 2016 and Samba 4.24.7 all four are
STATUS_SUCCESS and it prints PASS.

---8<--- smb2-related-qi.c ---8<---
/*
 * smb2-related-qi: send a compound of two QUERY_INFO requests on an open
 * file, the first with the real FileId and the second with the related
 * operation placeholder FileId 0xFFFFFFFFFFFFFFFF, and print the status
 * of each reply.
 *
 * MS-SMB2 3.3.5.2.7.2: the second request must use the FileId of the
 * first one, which "contains" a FileId. Windows does that and returns
 * STATUS_SUCCESS for both.
 *
 * As a control the same two queries are then sent as an unrelated
 * compound, both with the real FileId.
 *
 * Build against libsmb2 (https://github.com/sahlberg/libsmb2, master):
 *   gcc -o smb2-related-qi smb2-related-qi.c $(pkg-config --cflags
--libs libsmb2)
 *
 * Usage:
 *   smb2-related-qi smb://[domain;][user@]server/share/path/to/file
 * The password is read from the file NTLM_USER_FILE points to, one
 * DOMAIN:USERNAME:PASSWORD line per user.
 */

#include <fcntl.h>
#include <inttypes.h>
#include <poll.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <smb2/smb2.h>
#include <smb2/libsmb2.h>
#include <smb2/libsmb2-raw.h>

struct query {
        const char *name;
        int done;
        uint32_t status;
};

static void
qi_cb(struct smb2_context *smb2, int status, void *command_data,
      void *private_data)
{
        struct query *q = private_data;
        struct smb2_query_info_reply *rep = command_data;

        q->done = 1;
        q->status = (uint32_t)status;
        if (status == 0 && rep != NULL) {
                smb2_free_data(smb2, rep->output_buffer);
        }
}

static int
run(struct smb2_context *smb2, struct smb2fh *fh, int related)
{
        struct smb2_query_info_request req;
        struct smb2_pdu *pdu, *next;
        struct query q1 = { .name = "QUERY_INFO FileAttributeTagInformation" };
        struct query q2 = { .name = "QUERY_INFO FileAllInformation" };

        printf("%s compound:\n", related ? "Related" : "Unrelated");

        memset(&req, 0, sizeof(req));
        req.info_type = SMB2_0_INFO_FILE;
        req.output_buffer_length = 65535;
        memcpy(req.file_id, smb2_get_file_id(fh), SMB2_FD_SIZE);

        req.file_info_class = SMB2_FILE_ATTRIBUTE_TAG_INFORMATION;
        pdu = smb2_cmd_query_info_async(smb2, &req, qi_cb, &q1);

        req.file_info_class = SMB2_FILE_ALL_INFORMATION;
        if (related) {
                /* "use the FileId of the previous operation" */
                memset(req.file_id, 0xff, SMB2_FD_SIZE);
        }
        next = smb2_cmd_query_info_async(smb2, &req, qi_cb, &q2);
        if (pdu == NULL || next == NULL) {
                printf("failed to create the requests: %s\n",
                       smb2_get_error(smb2));
                return -1;
        }
        if (related) {
                smb2_add_compound_pdu(smb2, pdu, next);
        } else {
                smb2_add_unrelated_compound_pdu(smb2, pdu, next);
        }
        smb2_queue_pdu(smb2, pdu);

        while (!q1.done || !q2.done) {
                struct pollfd pfd;

                pfd.fd = smb2_get_fd(smb2);
                pfd.events = smb2_which_events(smb2);
                if (poll(&pfd, 1, 1000) < 0) {
                        perror("poll");
                        return -1;
                }
                if (pfd.revents && smb2_service(smb2, pfd.revents) < 0) {
                        printf("smb2_service failed: %s\n",
                               smb2_get_error(smb2));
                        return -1;
                }
        }

        printf("  %-40s FileId %-18s -> 0x%08" PRIx32 " %s\n", q1.name,
               "<real>", q1.status, nterror_to_str(q1.status));
        printf("  %-40s FileId %-18s -> 0x%08" PRIx32 " %s\n", q2.name,
               related ? "0xFFFFFFFFFFFFFFFF" : "<real>", q2.status,
               nterror_to_str(q2.status));
        return q1.status == 0 && q2.status == 0 ? 0 : 1;
}

int main(int argc, char *argv[])
{
        struct smb2_context *smb2;
        struct smb2_url *url;
        struct smb2fh *fh;
        int ret;

        if (argc != 2) {
                fprintf(stderr, "Usage: %s smb://[user@]server/share/file\n",
                        argv[0]);
                return 2;
        }
        smb2 = smb2_init_context();
        url = smb2_parse_url(smb2, argv[1]);
        if (url == NULL || url->path == NULL || url->path[0] == 0) {
                fprintf(stderr, "Bad URL, it must name a file: %s\n",
                        smb2_get_error(smb2));
                return 2;
        }
        if (smb2_connect_share(smb2, url->server, url->share,
                               url->user) < 0) {
                fprintf(stderr, "connect failed: %s\n", smb2_get_error(smb2));
                return 2;
        }
        fh = smb2_open(smb2, url->path, O_RDONLY);
        if (fh == NULL) {
                fprintf(stderr, "open %s failed: %s\n", url->path,
                        smb2_get_error(smb2));
                return 2;
        }

        ret = run(smb2, fh, 1);
        if (run(smb2, fh, 0) != 0) {
                ret = 2;
        }
        printf("%s\n", ret == 0 ? "PASS" :
               ret == 1 ? "FAIL: related compound rejected" :
               "ERROR: control (unrelated compound) failed too");

        smb2_close(smb2, fh);
        smb2_disconnect_share(smb2);
        smb2_destroy_url(url);
        smb2_destroy_context(smb2);
        return ret;
}
---8<---

Thanks,
Ronnie Sahlberg
