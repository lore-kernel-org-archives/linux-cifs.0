From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] [CIFS] Allow setting per-file compression via SMB3
Date: Tue, 08 Oct 2013 09:16:10 +0200
Message-ID: <5253B13A.3070403@samba.org>
References: <CAH2r5muzG6m8UAc5_OEKT5FGtk-FJgtSH2FaVgQFvmvnR0znZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Steve French <smfrench@gmail.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5muzG6m8UAc5_OEKT5FGtk-FJgtSH2FaVgQFvmvnR0znZg@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve,

> Allow cifs/smb2/smb3 to return whether or not a file is compressed
> via lsattr, and allow SMB3 to set the per-file compression flag
> ("chattr +c filename" on an smb3 mount).

Why is this SMB3 specific?

> Windows users often set the compressed flag (it can be
> done from the desktop and file manager).  David Disseldorp
> has patches to Samba server to support this (at least on btrfs)
> which are complementary to this.
>=20
> Wish chattr supported the per-file encryption flag (that
> presumably would be easy to set too via SMB3)

It seems there're some unrelated changes in the commit,
wouldn't it be better to split this into 2 or 3 commits?

metze
