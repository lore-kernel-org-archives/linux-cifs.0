From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [[PATCH v2] [CIFS] Allow setting per-file compression via SMB2
 and SMB3
Date: Thu, 10 Oct 2013 08:25:09 +0200
Message-ID: <52564845.9040205@samba.org>
References: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: Steve French <smfrench@gmail.com>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve,

> Allow cifs/smb2/smb3 to return whether or not a file is compressed
> via lsattr, and allow SMB2/SMB3 to set the per-file compression
> flag ("chattr +c filename" on an smb2 or smb3 mount).

There're still unrelated generic fixes in SMB2_ioctl(), which would
a separate commit.

I also don't understand why the set operation should not be available
in all protocols, there's nothing SMB2 or SMB3 specific.

metze
