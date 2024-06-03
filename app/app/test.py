from django.test import SimpleTestCase
from app import calc


class CalcTests(SimpleTestCase):
    def test_add(self):
        res = calc.add(6, 5)
        self.assertEqual(res, 11)

    def test_sub(self):
        res = calc.sub(10, 8)
        self.assertEqual(res, 2)


