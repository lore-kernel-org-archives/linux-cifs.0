From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/15] SMB3 encryption support
Date: Wed, 1 Feb 2017 14:05:02 -0600
Message-ID: <CAH2r5mtMUJTpskgFwY0q5o=mfK2v-USsgC1N-aFMe=9YRbFeZQ@mail.gmail.com>
References: <1481061758-52020-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481061758-52020-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged current version (with minor formatting update to patch 4 in the
series) into cifs-2.6.git for-next


This is fantastic work - great news.  And thanks for those
(David/Aurelien) who have tried these out and given feedback.

Encryption support is very helpful, and the ongoing work to improve
async read operations even more and compounding is very exciting.

On Tue, Dec 6, 2016 at 4:02 PM, Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
> This patchset adds encryption support when SMB3 version of the protocol and higher is negotiated.
> The encryption is done through the kernel crypto API (CCM(AES)).
>
> The patchset has been successfully tested by xfstests and cthon test suites with encrypted file shares on Samba.
>
> Patches are split into several groups:
>  1) #1-#4: prepare transport infractructure to be able to send SMB3 transform header;
> this is done primarily by separating RFC1001 length and SMB2 header into different iovs.
>  2) #5-#6: simplify SMB2 header processing and cleaning up a read codepath.
>  3) #7-#9: encrypt outcoming packets by transforming them before sending.
>  4) #10-#14: decrypt incoming packets and pass ordinary SMB2 messages for further usual processing.
>  5) #15: allow to use "seal" mount option to request the encryption on a share.
>
> Pavel Shilovsky (15):
>   CIFS: Separate SMB2 header structure
>   CIFS: Make SendReceive2() takes resp iov
>   CIFS: Make send_cancel take rqst as argument
>   CIFS: Send RFC1001 length in a separate iov
>   CIFS: Separate SMB2 sync header processing
>   CIFS: Separate RFC1001 length processing for SMB2 read
>   CIFS: Add capability to transform requests before sending
>   CIFS: Enable encryption during session setup phase
>   CIFS: Encrypt SMB3 requests before sending
>   CIFS: Add transform header handling callbacks
>   CIFS: Add mid handle callback
>   CIFS: Add copy into pages callback for a read operation
>   CIFS: Decrypt and process small encrypted packets
>   CIFS: Add capability to decrypt big read responses
>   CIFS: Allow to switch on encryption with seal mount option
>
>  fs/cifs/cifsencrypt.c   |  51 ++--
>  fs/cifs/cifsglob.h      |  28 ++-
>  fs/cifs/cifsproto.h     |  13 +-
>  fs/cifs/cifssmb.c       | 135 +++++-----
>  fs/cifs/connect.c       |  71 ++++--
>  fs/cifs/file.c          |  52 +++-
>  fs/cifs/sess.c          |  27 +-
>  fs/cifs/smb1ops.c       |   4 +-
>  fs/cifs/smb2glob.h      |   5 +
>  fs/cifs/smb2maperror.c  |   5 +-
>  fs/cifs/smb2misc.c      |  61 ++---
>  fs/cifs/smb2ops.c       | 651 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/cifs/smb2pdu.c       | 575 +++++++++++++++++++++++++++---------------
>  fs/cifs/smb2pdu.h       |  27 +-
>  fs/cifs/smb2proto.h     |   5 +
>  fs/cifs/smb2transport.c | 132 ++++++----
>  fs/cifs/transport.c     | 171 ++++++++-----
>  17 files changed, 1540 insertions(+), 473 deletions(-)
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
