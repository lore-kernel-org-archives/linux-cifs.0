From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: [PATCH v5 4/7] CIFS: Use NT_CREATE_ANDX command for forcemand
	mounts
Date: Wed, 10 Apr 2013 17:59:28 +0400
Message-ID: <CAKywueQ9quCRZJocxwsg=hzS1eEzM0jCB-RAQwzYa7dWeEEoUQ@mail.gmail.com>
References: <1365511227-17626-1-git-send-email-piastry@etersoft.ru>
	<1365511227-17626-5-git-send-email-piastry@etersoft.ru>
	<20130410071144.08ef2983@corrin.poochiereds.net>
	<CAKywueSPh2vXvS1HRmJHZUApo_YxWjcp4_2ZXgb1RHafS=A98w@mail.gmail.com>
	<20130410081221.753e4bb3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
	Linux NFS Mailing list <linux-nfs@vger.kernel.org>,
	wine-devel@winehq.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20130410081221.753e4bb3@corrin.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

2013/4/10 Jeff Layton <jlayton@samba.org>:
> (cc'ing samba-technical)
>
> I don't understand. Why would we need to use NT_CREATE_ANDX in lieu of
> the POSIX trans2 open if the client isn't setting a share reservation
> on that particular open? The server should still enforce share
> reservations that are already set on the file regardless of which
> method is used.

Ok, I checked it out: Samba still enforce share reservations for
trans2 opens too. In this case we need a check like

if (IS_SHARELOCK(inode) && cifs_get_share_flags(openflags) != FILE_SHARE_ALL)
        /* use NT_CREATE_ANDX */
else
       /* use TRANS2 OPEN */

--
Best regards,
Pavel Shilovsky.
