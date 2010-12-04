From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 06:30:50 -0600
Message-ID: <AANLkTinj=G1U+YD9a-mcrOp65gW7HwE+DOZBmJccYpbR@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org> <E1POnFL-00BKg9-JW@intern.SerNet.DE>
	<20101204064452.46ac24c7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, "Christopher R. Hertel" <crh@samba.org>,
	Volker.Lendecke@sernet.de, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101204064452.46ac24c7@tlielax.poochiereds.net>
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

Is SMB Echo command the only way to determine whether to reconnect or not?
The assumption here is SMB server is unresponsive.
There could be other circumstances on the server box (or even client box)
that are slowing_down/grinding_down the SMB server responses such as
slow network, slow network stack, memory pressure etc.
SMB Server could be fine all along and yet client reconnects.
