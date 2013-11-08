From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Re: [PATCH] cifs: change ERRnomem error mapping from ENOMEM to EREMOTEIO
Date: Sat, 09 Nov 2013 02:04:37 +0900
Message-ID: <527D19A5.1040000@yk.rim.or.jp>
References: <1383854555-12043-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383854555-12043-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(2013/11/08 5:02), Jeff Layton wrote:
> Sometimes, the server will report an error that basically indicates
> that it's running out of resources. These include these under SMB1:

 [...]

Thank you for taking care of the issue so quickly.

Chiaki Ishikawa
