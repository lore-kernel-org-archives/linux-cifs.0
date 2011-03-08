From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] FC: cifs: Initialized an uninitialized variable
Date: Mon, 7 Mar 2011 22:38:25 -0600
Message-ID: <AANLkTi==7wv6mrL5OWkGKxyc7GbKPH5+kgkCBNUcj3im@mail.gmail.com>
References: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
	<20110308042601.GX22723@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
	Vinay Sawal <vinaysawal@gmail.com>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110308042601.GX22723@ZenIV.linux.org.uk>
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

On Mon, Mar 7, 2011 at 10:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 07, 2011 at 08:00:09PM -0800, Vinay Sawal wrote:
>> Removed a compile time warning by initializing an uninitialized variable=
.
>
>> - =A0 =A0 int rc;
>> + =A0 =A0 int rc =3D -EFAULT;
>
> Why is that the right thing to do? =A0Other than "it made the compiler to
> STFU, therefore it is Good(tm)", please.

Hard to disagree with Al's logic, although changing the scope of rc to
within the for loop might also make both your compiler happy and more
sense.   In any case, I prefer real bug fixes.


--=20
Thanks,

Steve
