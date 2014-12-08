From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Revised patch to convert MessageID in smb2_hdr to LE
Date: Mon, 8 Dec 2014 16:30:58 -0600
Message-ID: <CAH2r5msxSvtbCzPOnTpvzas5Qg46O-SJqc05GA1i2Ts74uYPtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sachin,
Since your patch had various sparse warnings, I did a different
version, basically converting the SMB2/SMB3 MessageID field on the
wire  to le64 from u64 (we used to assume that the MessageId/MID was
opaque) and then modifying places that used it to match that
endianness.

Would you try that and make sure it works in your big endian
reproduction scenario (or propose an alternate patch)?



-- 
Thanks,

Steve
